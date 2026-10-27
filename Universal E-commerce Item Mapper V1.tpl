___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "sgtm_ecommerce_item_mapper_v4",
  "version": 1,
  "securityGroups": [],
  "displayName": "Universal E-commerce Item Mapper V1",
  "description": "Maps GA4 item Parameters to an array of values or an array of objects with configurable source and output fields. For example useable for content and content_id parameter of Facebook, etc. - Version 1",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "itemsEventKey",
    "displayName": "Input Event data key for items",
    "simpleValueType": true,
    "defaultValue": "items",
    "alwaysInSummary": true,
    "help": "Add here the Key of the Items Array, for example \"items\"."
  },
  {
    "type": "RADIO",
    "name": "outputMode",
    "displayName": "Output type",
    "radioItems": [
      {
        "value": "values",
        "displayValue": "Array of values"
      },
      {
        "value": "objects",
        "displayValue": "Array of objects"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "objects",
    "help": "Choose the output format. An Array of one item Parameter or an Array of Objects with different item Parameters."
  },
  {
    "type": "TEXT",
    "name": "valueSource",
    "displayName": "Source parameter for array of values",
    "simpleValueType": true,
    "defaultValue": "item_id",
    "enablingConditions": [
      {
        "paramName": "outputMode",
        "paramValue": "values",
        "type": "EQUALS"
      }
    ],
    "alwaysInSummary": true,
    "help": "Choose the item Parameter for the Output Array."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "fieldMappings",
    "displayName": "Item parameter mappings",
    "enablingConditions": [
      {
        "paramName": "outputMode",
        "paramValue": "objects",
        "type": "EQUALS"
      }
    ],
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Source item field",
        "name": "sourceField",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Output object key",
        "name": "targetField",
        "type": "TEXT"
      }
    ],
    "alwaysInSummary": true,
    "help": "Add the Mapping of item Parameters for the output Objects."
  }
]


___SANDBOXED_JS_FOR_SERVER___

// Reuqired APIs
const getEventData = require('getEventData');
const getType = require('getType');

// Varaible Declaration
const items = getEventData(data.itemsEventKey || 'items');
const output = [];
const mode = data.outputMode || 'objects';
const mappings = getType(data.fieldMappings) === 'array' ? data.fieldMappings : [];

// Check Datatype of items
if (getType(items) !== 'array') {
  return undefined;
}

// Loop through input value
for (let i = 0; i < items.length; i++) {
  const item = items[i];
  if (getType(item) !== 'object') {
    continue;
  }
// Generating output for Array values
  if (mode === 'values') {
    const source = data.valueSource || 'item_id';
    const value = item[source];
    output.push(value === undefined ? null : value);
  }
// Generating output for Array of objects
  else {
    const mapped = {};
    for (let j = 0; j < mappings.length; j++) {
      const row = mappings[j];
      if (!row || !row.sourceField || !row.targetField) {
        continue;
      }
      const value = item[row.sourceField];
      if (value !== undefined) {
        mapped[row.targetField] = value;
      }
    }
    output.push(mapped);
  }
}
return output;


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 27.10.2026, 09:30:00
