class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def javascript_variables(variables)
    @javascript_variables ||= {}
    @javascript_variables.merge!(variables)
  end
end
