#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

def say(message)
  puts message
end

def make_script_body(commands)
  say 'These following commands are used in this hook:'

  commands.each do |command|
    say "- #{command}"
  end

  if commands.empty?
    "#!/bin/sh\n\n# No commands defined for this hook\nexit 0\n"
  else
    "#!/bin/sh\n\n#{commands.join("\n")}\n"
  end
end

# Steps
# 1. Notify user that we're going to setup git hooks
# 2. Define hash of hooks & commands to run in each hook
# 3. Check if the hook file exists, if not create it, otherwise overwrite
# 4. Make the hook script executable
# 5. Notify user that we're done

say '🪝 Setting up git hooks...'

# Define hooks and their commands
hooks_and_commands = {
  'pre-commit' => [
    <<~HOOK
      # Auto-format staged Swift files
      git diff --staged --diff-filter=d --name-only | grep -e '\\(.*\\).swift$' | while read line; do
          swiftformat "$line"
          git add "$line"
      done
    HOOK
  ],
  'pre-push' => [
    <<~HOOK
      # Run SwiftLint before push
      echo "🔍 Running SwiftLint..."
      swiftlint --quiet
      LINT_RESULT=$?
      if [ $LINT_RESULT -ne 0 ]; then
          echo "❌ SwiftLint found issues. Please fix them before pushing."
          exit 1
      fi
      echo "✅ SwiftLint passed"
    HOOK
  ],
  'post-checkout' => [
    'rake arkana',
    'rake swiftgen'
  ],
  'post-merge' => [
    'rake install',
    'rake arkana',
    'rake swiftgen'
  ]
}

# Check if hooks folder exists
say 'Checking if hooks folder exists...'
unless File.directory?('.git/hooks')
  FileUtils.mkdir_p('.git/hooks')
  say '📁 Created hooks folder'
else
  say '💡 Hooks folder found'
end

# Create or overwrite hook files
hooks_and_commands.each do |hook, commands|
  hook_file_path = ".git/hooks/#{hook}"
  if File.exist?(hook_file_path)
    say "🪝 Overwriting #{hook} hook..."
  else
    say "🪝 Creating #{hook} hook..."
  end
  File.write(hook_file_path, make_script_body(commands))
end

# Make hook scripts executable
hooks_and_commands.each_key do |hook|
  hook_file_path = ".git/hooks/#{hook}"
  say "🔐 Making #{hook} hook executable..."
  system("chmod +x #{hook_file_path}")
end

say '✅ Done setting up git hooks!'
