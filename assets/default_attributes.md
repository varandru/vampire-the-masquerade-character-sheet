# Default Attributes JSON

### Locale
```json
  "locale": "en-US", 
```
Locale, in a format that Flutter understands

### Level Prefixes

```json
"level_prefixes": [
  {
    "level": 1,
    "prefix": "Poor"
  },
  ...
],
```

These go in front of levels. Can be empty, but the field `level_prefixes` must be present.

### Stat description

* `name` and `specialization` are mandatory fields. The rest can be omitted.
* `specialization` can be empty
* `levels.level` must be contigous. `max_level` goes up to the maximum level in it.
* As long as they are available, prefixes will be used in levels.

TODO: probably, only descriptions are neccessary.


```json
  "physical": [
    {
      "name": "Strength",
      "specialization": [
        "Specialization 1",
        "Specialization 2"
      ],
      "max_level": 1,
      "levels": [
        {
          "level": 1,
          "description": "You can lift 40 lbs (about 20  kgs)."
        }
      ],
      "description": "Descriptions go here"
    }
  ]
}
```