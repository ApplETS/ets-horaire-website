set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'scheduler.clubapplets.ca', user: 'ubuntu', roles: %w{web app db}

set :ssh_options, {
	keys: %w(~/.gnupg/AppletsKeypair.pem),
	forward_agent: true
}

fetch(:default_env).merge!(wp_env: :production)