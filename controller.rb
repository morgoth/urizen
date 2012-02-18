layout /.*html.haml/ => 'layout.html.haml'
ignore "Gemfile", "Gemfile.lock", "credentials.yaml", "Rakefile", "README.md"
# Ignore filenames with an underscore at the beginning:
ignore /\/_.*/
