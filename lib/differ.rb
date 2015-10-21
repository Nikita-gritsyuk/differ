require "open3"
require 'json'
require "differ/version.rb"

module Differ
  class Diff
    def set_diff_files (path1, path2)
      #create Open3 caller
      diff = Open3.popen3(diff_bin, *["-u","-b"], *([path1, path2])) { |i, o, e| o.read }
      # set encoding, if have problems
      diff.force_encoding('ASCII-8BIT') if diff.respond_to?(:valid_encoding?) && !diff.valid_encoding?
      # set remove \r and split response by lines
      lines = diff.gsub("\r", "").split("\n").drop(2)
      # remove not information without chenges
      lines.delete_if {|line| !['+','-',' ','*'].include? line[0] }
      # loop for glue + and - chenges to *
      lines.each_cons(2).with_index do |lines_vals, i|
        line, next_line = lines_vals
        if line[0] == "-" and next_line[0] == "+" then
          line[0]="*"
          next_line[0]=""
          lines[i] = "#{line} | #{next_line}"
          lines[i+1] = ""
        end
      end
      # form lines array and return
      @lines = lines.map{|line| [status: line[0], string: line[1..-1]] if !line.empty?}.compact
    end
    #generate JSON
    def to_json
      JSON.generate(@lines)
    end
    #generate string
    def to_s
      @lines.map.with_index{|val, i| "#{i} #{val[0][:status]} #{val[0][:string]}"}.join("\n")
    end
    #constructor
    def initialize(path1, path2)
      set_diff_files(path1, path2)
    end
    #return arr
    def to_a
      @lines
    end
    #generate ANSI colored log
    def to_color_log
      @lines.map.with_index do |val, i|
          case val[0][:status]          
          when " "
            "\033[90m#{i} #{val[0][:status]} #{val[0][:string]}\033[0m"
          when "+"
            "\033[32m#{i} #{val[0][:status]} #{val[0][:string]}\033[0m"
          when "-"
            "\033[31m#{i} #{val[0][:status]} #{val[0][:string]}\033[0m"
          when "*"
            "\033[36m#{i} #{val[0][:status]} #{val[0][:string]}\033[0m"
          end
        end.join("\n") + "\n"
    end

    private
    @lines = []
    # get diff path
    def diff_bin
      # possible bins
      diffs = ['diff', 'ldiff']
      #find system
      bin = diffs.find { |name| system(name, __FILE__, __FILE__) }
      #catch nill error
      if bin.nil?
        raise "Can't find a diff executable in PATH #{ENV['PATH']}"
      end
      bin
    end
  end 
end