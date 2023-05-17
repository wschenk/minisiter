# Mini-Site-R

Simple template to setup and deploy a quick site focused on exposing a script output to the web.

The idea is that you can write up something on the CLI and quickly turn it into a site, and then go from there.

If your script is long running, it uses polling to see if the job is done. You can store this state in the filesystem (fine for one process) or in redis if multiple client instances are running.

If you pass parameters in the URL (e.g. use the **GET** method links will work)

## Features

- Nice clean devcontainer to run everything in
- Semantic HTML CSS
- htmx
- Tailwindcss
- Sinatra
- Meant to be deployed on fly.io

## Usage

1. Clone the repo
2. Write your script however you want
3. Use `./run` to start up the local dev environment
4. Wire up the UI, adding additional arguments if needed:
5. Fiddle with the design as needed, `npm run dev` will update `main.css`
6. Deploy the app

## Limiting access

Maybe you don't want the whole world to be able to run the app?

Set `MINISTER_PASSWORD` to the site password. e.g.

```
$ MINISTER_PASSWORD=testpassword ./run
```

or

```
fly secret set MINISTER_PASSWORD=mypassword
```

## Wiring up the UI

- If it's quick running replace `/` with the `/inline` route.
- If it's long running on one server replace `/` with `/fs_polling` route.
- If you are deploying this on multiple instances use `/redis_polling`

There are a few examples implemented that run different scripts.

If you have a long running script (simulated in the script `delay` with a 3 second sleep) you can store the running result either in the file system or in Redis. The file system is simplier but if you have multiple machines it will probably spawn the process multiple times.

| Script        | Storage | Example url      |
| ------------- | ------- | ---------------- |
| `./immediate` | None    | `/inline`        |
| `./delay`     | `/tmp`  | `/fs_polling`    |
| `./delay`     | Redis   | `/redis_polling` |

### Fonts

You can set the heading font inside of `views/layout.erb` using CSS variables.

## Deployment

- `fly auth login` to authorize
- `fly launch` to setup `fly.toml`
- `fly deploy` to get it online

### Redis

- `fly redis connect`
- `fly secrets set REDIS_URL=` to wire up a redis database to your app (need the connect string from `fly redis status`)

### Domain

Instructions for [setting up a custom domain](https://fly.io/docs/app-guides/custom-domains-with-fly/#teaching-your-app-about-custom-domains)

Basically point a `CNAME` to your fly.io site and do `flyctl certs create example.com`.
