# frozen_string_literal: true

require 'fileutils'

# Default task
task default: :setup

desc 'Complete project setup'
task setup: %i[
  check_ruby_version
  install_bundler
  bundle_install
  install_git_hooks
  setup_arkana
  install_swiftformat
  install_swiftlint
  summary
]

desc 'Check Ruby version'
task :check_ruby_version do
  puts '🔍 Checking Ruby version...'
  required_version = '3.3.0'
  current_version = RUBY_VERSION

  if current_version != required_version
    puts "⚠️  Warning: Expected Ruby #{required_version}, but found #{current_version}"
    puts '   Consider using rbenv or rvm to switch versions'
  else
    puts "✅ Ruby version #{current_version} matches requirement"
  end
end

desc 'Install bundler if not present'
task :install_bundler do
  puts '📦 Checking for bundler...'
  if system('which bundle > /dev/null 2>&1')
    puts '✅ Bundler already installed'
  else
    puts '⬇️  Installing bundler...'
    system('gem install bundler') || abort('❌ Failed to install bundler')
  end
end

desc 'Install Ruby dependencies'
task :bundle_install do
  puts '📦 Installing Ruby dependencies...'
  system('bundle install') || abort('❌ Failed to install dependencies')
  puts '✅ Ruby dependencies installed'
end

desc 'Install git hooks'
task :install_git_hooks do
  puts '🔧 Installing git hooks...'
  if File.exist?('Scripts/git-hooks.rb')
    system('ruby Scripts/git-hooks.rb') || abort('❌ Failed to install git hooks')
    puts '✅ Git hooks installed'
  else
    puts '⚠️  Git hooks script not found, skipping...'
  end
end

desc 'Setup Arkana for secrets management'
task :setup_arkana do
  puts '🔐 Setting up Arkana...'

  # Check if .env files exist
  env_files = Dir.glob('.env*')

  if env_files.empty?
    puts '⚠️  No .env files found. You may need to create them manually:'
    puts '   - .env.Debug'
    puts '   - .env.Beta'
    puts '   - .env.Release'
    puts '   Skipping Arkana generation...'
  else
    puts "📄 Found environment files: #{env_files.join(', ')}"
    puts '⬇️  Running Arkana to generate secrets...'
    system('bundle exec arkana') || puts('⚠️  Arkana generation failed - you may need to configure your .env files')
  end
end

desc 'Install SwiftFormat'
task :install_swiftformat do
  puts '🎨 Checking for SwiftFormat...'
  if system('which swiftformat > /dev/null 2>&1')
    puts '✅ SwiftFormat already installed'
  else
    puts '⬇️  Installing SwiftFormat via Homebrew...'
    if system('which brew > /dev/null 2>&1')
      system('brew install swiftformat') || puts('⚠️  Failed to install SwiftFormat')
    else
      puts '⚠️  Homebrew not found. Please install SwiftFormat manually:'
      puts '   brew install swiftformat'
    end
  end
end

desc 'Install SwiftLint'
task :install_swiftlint do
  puts '🔍 Checking for SwiftLint...'
  if system('which swiftlint > /dev/null 2>&1')
    puts '✅ SwiftLint already installed'
  else
    puts '⬇️  Installing SwiftLint via Homebrew...'
    if system('which brew > /dev/null 2>&1')
      system('brew install swiftlint') || puts('⚠️  Failed to install SwiftLint')
    else
      puts '⚠️  Homebrew not found. Please install SwiftLint manually:'
      puts '   brew install swiftlint'
    end
  end
end

desc 'Format Swift code in project'
task :format_project do
  puts '🎨 Formatting project Swift code...'

  swift_files = Dir.glob('WeatherApp/**/*.swift')

  if swift_files.empty?
    puts '⚠️  No Swift files found in project, skipping formatting...'
  else
    system('swiftformat WeatherApp') || abort('❌ SwiftFormat failed')
    puts '✅ Project code formatted'
  end
end

desc 'Format Swift code in packages'
task :format_packages do
  puts '🎨 Formatting packages Swift code...'

  swift_files = Dir.glob('Packages/**/*.swift')

  if swift_files.empty?
    puts '⚠️  No Swift files found in packages, skipping formatting...'
  else
    system('swiftformat Packages') || abort('❌ SwiftFormat failed')
    puts '✅ Packages code formatted'
  end
end

desc 'Format all Swift code (project and packages)'
task format: %i[format_project format_packages]

desc 'Lint Swift code in project'
task :lint_project do
  puts '🔍 Linting project Swift code...'

  swift_files = Dir.glob('WeatherApp/**/*.swift')

  if swift_files.empty?
    puts '⚠️  No Swift files found in project, skipping linting...'
  else
    system('swiftlint WeatherApp') || abort('❌ SwiftLint failed')
    puts '✅ Project code linted'
  end
end

desc 'Lint Swift code in packages'
task :lint_packages do
  puts '🔍 Linting packages Swift code...'

  swift_files = Dir.glob('Packages/**/*.swift')

  if swift_files.empty?
    puts '⚠️  No Swift files found in packages, skipping linting...'
  else
    system('swiftlint Packages') || abort('❌ SwiftLint failed')
    puts '✅ Packages code linted'
  end
end

desc 'Lint all Swift code (project and packages)'
task lint: %i[lint_project lint_packages]

desc 'Run linting and formatting on everything'
task check: %i[lint format]

desc 'Check if SwiftGen is installed'
task :check_swiftgen do
  unless system('which swiftgen > /dev/null 2>&1')
    puts '❌ SwiftGen not found. Installing...'
    if system('which brew > /dev/null 2>&1')
      system('brew install swiftgen') || abort('❌ Failed to install SwiftGen')
    else
      abort('❌ Homebrew not found. Please install SwiftGen manually: brew install swiftgen')
    end
  end
end

desc 'Generate code using SwiftGen (colors, strings, assets)'
task generate: :check_swiftgen do
  puts '🎨 Generating code from assets using SwiftGen...'
  if File.exist?('swiftgen.yml')
    system('swiftgen') || abort('❌ SwiftGen generation failed')

    # Generate L10n from .xcstrings using custom script
    puts '🌍 Generating L10n from String Catalog...'
    xcstrings_path = 'Packages/Content/Sources/Content/Resources/Localizable.xcstrings'
    output_path = 'Packages/Content/Sources/Content/Generated/L10n+Generated.swift'
    script_path = 'Scripts/generate-l10n.swift'

    if File.exist?(xcstrings_path) && File.exist?(script_path)
      system("swift #{script_path} #{xcstrings_path} #{output_path}") || abort('❌ L10n generation failed')
    else
      puts "⚠️  L10n generation skipped - missing required files"
    end

    puts '✅ Code generation complete'
  else
    puts '⚠️  swiftgen.yml not found, skipping...'
  end
end

desc 'Generate localization files (legacy - use generate instead)'
task :generate_l10n do
  puts '🌍 Generating localization files...'
  if File.exist?('Scripts/generate-l10n.rb')
    system('ruby Scripts/generate-l10n.rb') || abort('❌ Failed to generate localization')
    puts '✅ Localization files generated'
  else
    puts '⚠️  Localization script not found, skipping...'
  end
end

desc 'Clean build artifacts'
task :clean do
  puts '🧹 Cleaning build artifacts...'
  system('rm -rf ~/Library/Developer/Xcode/DerivedData/WeatherApp-*')
  system('rm -rf .build')
  puts '✅ Clean complete'
end

desc 'Show setup summary'
task :summary do
  puts "\n" + '=' * 50
  puts '✅ Setup Complete!'
  puts '=' * 50
  puts "\nNext steps:"
  puts '1. Create your .env files (.env.Debug, .env.Beta, .env.Release)'
  puts '2. Run `bundle exec arkana` to generate secrets'
  puts '3. Open WeatherApp.xcodeproj in Xcode'
  puts "\nAvailable rake tasks:"
  puts '  rake setup           - Run complete setup'
  puts '  rake format          - Format all Swift code (project + packages)'
  puts '  rake format_project  - Format project Swift code only'
  puts '  rake format_packages - Format packages Swift code only'
  puts '  rake lint            - Lint all Swift code (project + packages)'
  puts '  rake lint_project    - Lint project Swift code only'
  puts '  rake lint_packages   - Lint packages Swift code only'
  puts '  rake check           - Run linting and formatting on everything'
  puts '  rake generate        - Generate code from assets (colors, strings, etc.)'
  puts '  rake clean           - Clean build artifacts'
  puts "\nFor more tasks, run: rake -T"
  puts '=' * 50
end
