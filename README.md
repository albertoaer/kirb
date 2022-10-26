# Kirb

Minimalist extensible ruby HTTP framework

## How does it works?

When the server receives and parses an incoming HTTP request the process start:

- The first step is to create a context
- The guards will try to match the request and inject models into the context
- If the guards successfully accepts the request and inject the models
  - The context is passed to the middleware block associated
  - The middleware will be a bridge between the http data and the services
  - The middleware can delegate and await other controllers calling `next()`