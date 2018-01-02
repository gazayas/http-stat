require "httpd/version"
require "httpd/statuses"

require "optparse"
require "colorize"

module Httpd
  OptionParser.new do |opts|
    opts.banner = "A command line tool for looking up the details of http (HyperText Transfer Protocol) statuses"
    opts.separator ""
    opts.separator "Options:"

    options = {}

    opts.on("-s [NUMBER]",
            OptionParser::DecimalInteger,
            "Shows the status with details if a number is selected. If no number, shows a master list of all statuses"
            ) do |i|
      if i == nil
        Statuses.each do |s|
          s[:number] = s[:number].to_s
          case s[:classification]
          when "Information response"
            print s[:number].colorize(:cyan)
          when "Success"
            print s[:number].colorize(:light_green)
          when "Redirection"
            print s[:number].colorize(:light_cyan)
          when "Client Error"
            print s[:number].colorize(:light_red)
          when "Server Error"
            print s[:number].colorize(:light_yellow)
          end

          print " #{s[:status]} (#{s[:classification]})\n"
        end
      else
        Statuses.each do |s|
          if s[:number] == i
            s[:number] = s[:number].to_s

            case s[:classification]
            when "Information response"
              print s[:number].colorize(:cyan)
            when "Success"
              print s[:number].colorize(:light_green)
            when "Redirection"
              print s[:number].colorize(:light_cyan)
            when "Client Error"
              print s[:number].colorize(:light_red)
            when "Server Error"
              print s[:number].colorize(:light_yellow)
            end

            if ARGV.include?("-jp")
              print " #{s[:status]} (#{s[:classification]})\n#{s[:details_jp]}\n"
            else
              print " #{s[:status]} (#{s[:classification]})\n#{s[:details]}\n"
            end

            break
          end
        end
      end
    end

    opts.on("-jp", "Shows status details in Japanese (日本語で詳細を表示します。-s [NUMBER]の後に定義。）") do |v|
      options[:jp] = v
    end

    opts.on_tail("-h", "--help", "Shows this") do |help|
      puts opts
    end

    opts.on_tail("-v", "--version", "Show version") do
      puts VERSION
      exit
    end
  end.parse!

# TODO...
=begin
  def self.colorize_and_print(str)
    case str[:classification]
    when "Information response"
      print s[:number].colorize(:cyan)
    when "Success"
      print s[:number].colorize(:light_green)
    when "Redirection"
      print s[:number].colorize(:light_cyan)
    when "Client Error"
      print s[:number].colorize(:light_red)
    when "Server Error"
      print s[:number].colorize(:light_yellow)
    end
  end
=end  
end
