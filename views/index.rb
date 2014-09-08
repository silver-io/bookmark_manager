<h1>Welcome to the bookmark manager</h1>
Current links:
<ul>
  <% @links.each do |link| %>
    <li><a href="<%= link.url %>"><%= link.title %></a></li>
  <% end %>
</ul>

get '/' do
  @links = Link.all
  erb :index
end