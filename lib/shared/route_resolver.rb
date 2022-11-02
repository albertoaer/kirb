module Kirb
  METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNET', 'OPTIONS', 'TRACE', 'PATCH']

  class InvalidRoute < StandardError
  end

  module RouteValidator
    @@route_word = '[^?\/#:]+'
    #TODO: Include query and fragment in the validation
    @@rotue_regex = /^\/(#{@@route_word}(\/#{@@route_word})*\/?)?$/
    
    def self.validate route
      @@rotue_regex.match? route
    end
  end

  class RouteResolver
    # any valid character in route part
    @@route_char = '[^?\/#:]'
    # any valid method name
    @@method_match = (METHODS + [":#{@@route_char}*"]).join '|'
    # validation of route
    @@route_regex = /^((#{@@method_match})#)?\/(((:#{@@route_char}*)|#{@@route_char}+)(\/((:#{@@route_char}*)|#{@@route_char}+))*\/?)?\/?$/

    attr_reader :matcher

    def initialize(route)
      raise InvalidRoute.new route unless @@route_regex.match? route
      regex_route = route.gsub(/:([#{@@route_char}])*/) { |s|
        s.length == 1 ? "#{@@route_char}+" : "(?<#{s[1..-1]}>#{@@route_char}+)"
      }
      regex_route = regex_route[0..-3] + '(?<*remain*>(\/.*)+)' if regex_route[-2..] == '//'
      unless regex_route =~ /^(#{@@method_match})#/
        regex_route = "(#{@@route_char}+#)?" + regex_route
      end
      @matcher = /^#{regex_route}$/
    end

    def resolve(route)
      matched = @matcher.match route
      unless matched.nil?
        matchs = matched.named_captures
        remain = matchs['*remain*']
        matchs.delete('*remain*')
        return true, matchs, remain
      end
      return false, nil, nil
    end
  end
end