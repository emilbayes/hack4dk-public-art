HACK4DK - Public Art
====================

> Visualisation of public art in Denmark, bought by Kunst Styrelsen (the Art Agency)

Development
-----------

Everything related to project life-cycle is managed by npm scripts. Javascript
is bundled using Browserify and CSS is bundled using CSSNext. HTML and static
assets are copied using `cp`. Note that the scripts will only work in a `sh`
(and might even require `bash`) shell due to `&`, `&&` and `wait`.

```bash
npm run watch # Watch css, js and serve assets on port 8000
npm run clean # Remove `dist` and bundle files
npm run bundle # Build everything to `dist`
```

Notes
-----

* Sometimes the time bought is missing, but the ID is the format
  `smk-[year-added]-[serial]`

Ideas
-----

- Quality of Art - A heuristic for the quality of art is art that has transitioned
                   into public museums. If it's in a museum it is probably part
                   of the national collection, and of higher quality.
- Distribution of features over time
  - Male vs Female Artists
  - Age of Artist at the time the piece is added to the collection
  - Geolocation (capital vs. province)

License
-------

[ISC](LICENSE)
