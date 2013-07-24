#encoding: utf-8
module ApplicationHelper
  def delete_action(resource, allowed = true, options = {})
    if allowed
      link_to("&nbsp;".html_safe, resource, :method => :delete, :data => { :confirm => "Tem certeza que deseja excluir este item?" }, :class => "icon-remove", :style => "text-decoration:none;")
    else
      options[:tooltip] ||= "Este item não pode ser excluído pois possui outros itens relacionados"
      content_tag(:i, "&nbsp;".html_safe, :class => "icon-remove", :style => "opacity:0.3;", :rel => "tooltip", :title => options[:tooltip])
    end
  end
end
