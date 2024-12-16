# Usage

- (Recommended) Install Homebrew on macOS
- (Recommended) Install either [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io) to manage Ruby versions.
- Use rbenv or rvm to install Ruby 3.3.5 (or whatever version is listed in `bin/Gemfile` of this project)
    - Note: using rvm on Apple Silicon, you may need to do the following to work around an OpenSSL build issue:
      ```
      brew install openssl@1.1
      rvm install 3.3.5 --with-openssl-dir="$(brew --prefix openssl@1.1)"
      ```
- Create `data/Enrollment info.csv` using the example file
- Create `data/name_spelling_corrections.json` with an empty object (`{ }`) for now (you’ll add to it)
- `cd bin` in project
- `bundle` to install dependencies
- Export survery responses from Google Sheets as a CSV
- Run the appropriate one of the following options:
    - `bundle exec ruby midterm_ratings.rb your_google_sheets_export_file.csv`
    - `bundle exec ruby final_ratings.rb your_google_sheets_export_file.csv`
- Update `name_spelling_corrections.json` as needed to handle students misspelling each other’s names / using nicknames
- When collator succeeds, it will open generated files in a browser
