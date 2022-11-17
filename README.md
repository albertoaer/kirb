# Kirb

Minimalist extensible ruby HTTP framework

```rb
Kirb::App.new do |ctr|
  # Create middleware to handle requests
  ctr.embed do
    content_type 'text/html' # Set content type header
    nxt # Run next middleware
  end

  # Protect routes using guards
  ctr.embed '/hello' do
    string '<h1>Hello World</h1>' # Send raw string
    status 200
  end

  # Default route
  ctr.embed do
    render 'not_found.erb' # Render from template
    status 404
  end
end.listen 3000 # Launch the web application !
```

## How to run it?

- Regular ruby file containing the app
```sh
$ ruby app.rb
```
- Using kirb command
```sh
$ kirb
```

## How does it work?

When the server receives and parses an incoming HTTP request the process start:

- The first step is to create a context
- The guards will try to match the request and inject models into the context
- If the guards successfully accepts the request and inject the models
  - The context is passed to the middleware block associated
  - The middleware will be a bridge between the http data and the services
  - The middleware can delegate and await other controllers calling `nxt` function