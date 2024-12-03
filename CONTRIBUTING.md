# Contributing to WordPress to Jekyll Markdown Cleaner

## How to Contribute

1. **Fork the Repository**
   - Click "Fork" on the GitHub repository page
   - Clone your forked repository locally

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Ensure code follows Ruby best practices
   - Add/update tests if applicable
   - Maintain consistent code style

4. **Test Your Changes**
   - Run existing tests
   - Add new tests for any new functionality
   - Verify script works with sample WordPress markdown files

5. **Commit Changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Describe the purpose and details of your changes
   - Reference any related issues

## Reporting Issues

- Use GitHub Issues
- Provide detailed description
- Include:
  - Ruby version
  - Input file examples
  - Full error traceback

## Code of Conduct

- Be respectful
- Collaborate constructively
- Welcome all skill levels

### Development Setup

1. Ensure Ruby 3.0+ is installed
2. Install required gems:
   ```bash
   gem install nokogiri fileutils cgi yaml date
   ```

## Local Testing

```bash
ruby wpMdCleaner.rb
```

Test with various WordPress markdown exports to ensure compatibility.