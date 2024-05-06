require 'bundler'; Bundler.require

require 'csv'
require 'set'
require 'haml'

@bin_dir     = File.dirname(__FILE__)
@scripts_dir = File.expand_path(File.join(@bin_dir, '..'))
@course_dir  = File.expand_path(File.join(@scripts_dir, '..'))
@data_dir    = File.join(@scripts_dir, 'data')

def projects_dir
  File.join(@course_dir, 'Projects')
end

def feebdack_dir
  File.join(@course_dir, 'Project feedback')
end

def data_file(filename)
  File.join(@data_dir, filename)
end

def render_haml(template, outfile, template_vars = {})
  haml_engine = Tilt.new(File.join(@bin_dir, "#{template}.haml"))
  
  File.write(
    outfile,
    haml_engine.render(Object.new, template_vars))
end
