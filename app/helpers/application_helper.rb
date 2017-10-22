module ApplicationHelper
    def javascript_variables(variables = nil)
        @javascript_variables ||= {}
        @javascript_variables.merge!(variables) if !variables.nil?
        return if @javascript_variables == {}
        
        output  = ''
        padding = @javascript_variables.keys.group_by(&:size).max.first
        
        @javascript_variables.each do |variable, value|
            output << "#{variable.to_s.ljust(padding)} = #{value.to_json},\n          "
        end
        
        raw "var " + output.strip.html_safe.gsub(/\,\Z/m, ';')
    end
end
