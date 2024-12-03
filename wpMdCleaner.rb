# Buildig on version-5 cleaner
# Restricts YAML to specific keys
# Gets date field from YAML and prefixes it in file name for jekyll use
# Summary: takes up the worpress to Gatsby exported md files as they are and converts them into final post-ready files by trimming second YAML, retaining only said YAML details, adding layout: post YAML and renaming the file with prefixing the publication date

require 'nokogiri'
require 'fileutils'
require 'cgi'
require 'yaml'
require 'date'

class MarkdownCleaner
  # Allowed YAML keys to retain
  ALLOWED_YAML_KEYS = [
    'title', 'date', 'status', 'permalink', 
    'author', 'excerpt', 'type', 'id', 
    'category', 'tag', 'layout'
  ]

  def initialize(input_dir, output_dir)
    @input_dir = convert_to_wsl_path(input_dir)
    @output_dir = convert_to_wsl_path(output_dir)
    
    # Ensure output directory exists
    FileUtils.mkdir_p(@output_dir)
  end

  def convert_to_wsl_path(path)
    path = path.gsub(/^[A-Z]:/, '/mnt/c')
    path = path.gsub('\\', '/')
    path.gsub(/\/+/, '/').chomp('/')
  end

  def clean_markdown_content(file_name, content)
    # Decode HTML entities
    content = CGI.unescapeHTML(content)

    # Extract all YAML blocks
    yaml_blocks = content.scan(/---\n(.*?)---\n/m)
    
    # Keep only the first YAML block
    if yaml_blocks.first
      # Parse the first YAML block
      yaml_data = YAML.safe_load(yaml_blocks.first[0])
      
      # Filter YAML to only allowed keys
      filtered_yaml_data = yaml_data.select { |key, _| ALLOWED_YAML_KEYS.include?(key) }
      
      # Ensure layout is set to 'post' if not specified
      filtered_yaml_data['layout'] = 'post' unless filtered_yaml_data.key?('layout')
      
      # Extract date for file naming
      date_for_filename = extract_date_prefix(filtered_yaml_data)
      
      # Convert back to YAML
      updated_yaml = filtered_yaml_data.to_yaml.gsub(/^---\n/, '').gsub(/\.\.\.\n$/, '')
      first_yaml = "---\n#{updated_yaml}---\n\n"
    else
      # If no YAML found, create a default one
      first_yaml = "---\nlayout: post\n---\n\n"
      date_for_filename = extract_date_from_filename(file_name)
    end

    # Remove all YAML blocks from content
    content_without_yaml = content.gsub(/---\n.*?---\n/m, '')

    # Parse the remaining content
    doc = Nokogiri::HTML(content_without_yaml)

    # Remove specific HTML tags while preserving content
    ['table', 'tbody', 'tr', 'td', 'div'].each do |tag|
      doc.xpath("//#{tag}").each do |element|
        # Replace with inner text, preserving line breaks
        inner_text = element.text.strip
        element.replace(inner_text + "\n") unless inner_text.empty?
      end
    end

    # Remove style and other unnecessary attributes
    doc.xpath('//*[@style or @class or @border or @cellpadding or @cellspacing or @width or @align]').each do |element|
      element.attributes.each do |name, _|
        element.remove_attribute(name)
      end
    end

    # Remove image wrapper divs, convert to markdown image syntax
    doc.xpath('//img').each do |img|
      src = img['src']
      alt = img['alt'] || ''
      img.replace("![#{alt}](#{src})")
    end

    # Cleanup and return text content
    cleaned_content = doc.text.strip

    # Combine first YAML block with cleaned content
    {
      content: first_yaml + cleaned_content,
      date_prefix: date_for_filename
    }
  end

  def extract_date_prefix(yaml_data)
    # Extract date from YAML
    return nil unless yaml_data['date']
    
    begin
      # Parse the date and extract just the date part
      date = DateTime.parse(yaml_data['date'])
      date.strftime('%Y-%m-%d')
    rescue ArgumentError
      nil
    end
  end

  def extract_date_from_filename(file_name)
    # Attempt to extract date from filename if no date in YAML
    match = file_name.match(/(\d{4}-\d{2}-\d{2})/)
    match ? match[1] : nil
  end

  def clean_files
    markdown_files = Dir.glob(File.join(@input_dir, '*.md'))
    
    puts "Input directory: #{@input_dir}"
    puts "Found #{markdown_files.count} markdown files"

    markdown_files.each do |file|
      puts "Processing file: #{file}"
      
      # Read the entire file content
      content = File.read(file)
      
      # Clean the content
      cleaned_result = clean_markdown_content(File.basename(file), content)
      
      # Prepare output filename
      base_filename = File.basename(file, '.md')
      date_prefix = cleaned_result[:date_prefix] || 'undated'
      
      # Create output filename with date prefix
      output_filename = "#{date_prefix}-#{base_filename}.md"
      output_file = File.join(@output_dir, output_filename)
      
      # Write to output file
      File.write(output_file, cleaned_result[:content])
      
      puts "Cleaned file saved: #{output_filename}"
    end
  end
end

# Usage
input_directory = 'C:/railsprojects/jekyll_practice/jekyll_clean/input_files/'
output_directory = 'C:/railsprojects/jekyll_practice/jekyll_clean/cleaned_md/'

cleaner = MarkdownCleaner.new(input_directory, output_directory)
cleaner.clean_files