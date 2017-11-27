# Classical Works Knowledge Base in JSON

This dataset includes all authors and works identified in the [Linked Data release (large RDF/XML file)](http://cwkb.org/allrecords/rdf) of the [Classical Works Knowledge Base (CWKB)](http://www.cwkb.org/), arranged hierarchically into a list of authors, each with a subordinate "works" list, all serialized into JavaScript Object Notation (JSON) format.

Here's a snippet of the content, formatted to show the general structure (NB ellipses):

```json
{
  "metadata": {
      ...
    },
  "authors": 
    [
      ...
      { 
        "id" : "927",
        "abbreviations" : [ "Hom." ],
        "names" : 
          [ 
            { "name" : "Homerus", "lang" : "la" },
            { "name" : "Omero", "lang" : "it" },
            { "name" : "Homère", "lang" : "fr" },
            { "name" : "Homer", "lang" : "en" },
            { "name" : "Homeros" } 
          ],
        "works" : 
          [ 
            { 
              "id" : "2814",
              "abbreviations" : [ "epigr." ],
              "titles" : [ { "title" : "Epigrammata", "lang" : "la" } ],
              "identifiers" : 
                [ "tlg:0012.003", "urn:cts:greekLit:tlg0012.tlg003" ],
              "languages" : [ "greek", "latin" ] 
            },          
            { 
              "id" : "2815",
              "abbreviations" : [ "Il." ],
              "titles" : 
                [ 
                  { "title" : "Ilias", "lang" : "la" },
                  { "title" : "Iliade", "lang" : "it" },
                  { "title" : "Ilias", "lang" : "de" },
                  { "title" : "L'Iliade", "lang" : "fr" },
                  { "title" : "Iliad", "lang" : "en" } 
                ],
              "identifiers" : 
                [ "tlg:0012.001", "urn:cts:greekLit:tlg0012.tlg001" ],
              "languages" : [ "greek", "latin" ] 
            },
            { 
              "id" : "2816",
              "abbreviations" : [ "Od." ],
              "titles" : 
                [ 
                  { "title" : "Odyssea", "lang" : "la" },
                  { "title" : "Odissea", "lang" : "it" },
                  { "title" : "Odyssee", "lang" : "de" },
                  { "title" : "l'Odyssée", "lang" : "fr" },
                  { "title" : "Odyssey", "lang" : "en" } 
                ],
              "identifiers" : 
                [ "tlg:0012.002", "urn:cts:greekLit:tlg0012.tlg002" ],
              "languages" :  [ "greek", "latin" ] 
            } 
          ] 
      },
      ...
    ]
}
```

Keys for authors and works make use of the unique identifying numbers found in the original CWKB RDF (e.g., where CWBK assigns an identifier like "http://cwkb.org/work/id/7960/rdf", the key value "7960" appears in the appropriate JSON object in the "works" array). Alternate names and abbreviations for authors, as well as titles and abbreviations for works, have also been replicated, as have external identifiers used by the Perseus Digital Library, the Packard Humanities Institute's online Latin texts, etc. The purpose of this JSON serialization is to facilitate use of the CWKB in web applications and other environments.

## Download and Usage

The CWKB JSON file may be downloaded from https://raw.githubusercontent.com/paregorios/cwkb-json/master/json/cwkb.json.

Some rudimentary usage in python is demonstrated in ```check-json.ipynb```. Your mileage may vary.

## Tooling and Requirements

The CWKB RDF/XML is converted to JSON using the bespoke ```rdf2json.xsl```file, which requires XSL 3.0. 

## Copyrights and Licenses

### The CWKB JSON dataset
The CWKB makes no explicit claim of copyright to the CWKB, but it does post [a bespoke open-ish license](http://cwkb.org/credits). Its text is replicated in the "metadata" section of the dataset, and also in the ```COPYING.cwkb.json.txt``` file, where additional terms have been added.

### The rdf2json.xsl stylesheet

Please see ```UNLICENSE.rdf2json.xsl.txt```. 

## Problems and Suggestions

You're welcome to open a ticket on [the issue tracker](https://github.com/paregorios/cwkb-json/issues), but what I really love are pull requests.



