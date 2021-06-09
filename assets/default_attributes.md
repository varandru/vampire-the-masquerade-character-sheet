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

* As long as they are available, prefixes will be used in levels.

**TODO**: probably, only level descriptions are neccessary.


```json
  "physical": [
    {
      "name": "Strength",
      "specialization": [
        "Specialization 1",
        "Specialization 2"
      ],
      "levels": [
        "You can lift 40 lbs (about 20  kgs)."
      ],
      "description": "Descriptions go here"
    }
  ]
}
```