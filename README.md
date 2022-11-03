# Kirb

Minimalist extensible ruby HTTP framework

```rb
Kirb::App.new do |ctr|
  # Use new middleware
  ctr.use do |ctx|
    ctx.response['Content-Type'] = 'text/html'
    ctx.response << '<h1>Hello World</h1>'
    ctx.status 200
  end
  # Or embed the middleware, just a syntactic difference
  ctr.embed do
    response['Content-Type'] = 'text/html'
    response << '<h1>Hello World</h1>'
    status 200
  end
end.listen 3000
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