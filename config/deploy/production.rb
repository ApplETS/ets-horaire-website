set :stage, :production

server 'krystosterone.com', user: 'deploy', roles: %w{web app}, primary: true