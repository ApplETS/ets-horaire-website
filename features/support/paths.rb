# encoding: utf-8

module NavigationHelpers
  def path_to(page_name)
    case page_name
      when "la page d'accueil"
        '/'
      when 'la page des résultats'
        '/resultats'
      when 'la page de Calendrier HTML'
        '/resultats/calendrier_html'
      when 'la page de Calendrier ASCII'
        '/resultats/calendrier_ascii'
      when 'la page de Liste Simple'
        '/resultats/liste_simple'
      else
        begin
          page_name =~ /la page (.*)/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue Object => e
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)