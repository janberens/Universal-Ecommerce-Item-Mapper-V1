# Universal Ecommerce Item Mapper (Server-Side GTM)

**Version:** 1  
**Template type:** Custom Variable Template 
**Container:** Google Tag Manager **Server** container  
**Template file:** [`sgtm_ecommerce_item_mapper_v6.tpl`]

## Overview

Universal Ecommerce Item Mapper transforms the `items` array in incoming GA4 event data into either:

- **An array of values**, using one source field from each item; or
- **An array of objects**, using a configurable table of source-to-output field mappings.

The template preserves the **original data types** of values (for example, strings remain strings and numbers remain numbers).
This makes it useful for preparing product-related parameters for downstream server-side tags, including Meta, Pinterest, Criteo, and other destinations. **The output is a reusable data structure, not a complete platform API payload.** Configure the destination tag according to its own field names and requirements.

## Requirements

- Access to a **server-side Google Tag Manager** container.
- A client, such as the GA4 Client, that claims incoming requests and exposes an `items` array in the server event data.
- Permission to import custom templates and create variables in the server container.

## Installation

1. Download `sgtm_ecommerce_item_mapper_v6.tpl` from this repository.
2. Open your **server-side** GTM container (not your web container).
3. Go to **Templates** → **Variable Templates**.
4. Click **New** to open the Template Editor.
5. Open the editor's **More actions (⋮)** menu and select **Import**.
6. Select `sgtm_ecommerce_item_mapper_v6.tpl`.
7. Review the template's **Fields**, **Code**, and **Permissions** tabs.
8. Confirm the required **Read Event Data** permission. The supplied template requests access to all event data.
9. Save the template as **Universal Ecommerce Item Mapper**.
10. Go to **Variables** → **New**, and choose the imported template as the variable type.

You can create multiple variables from the same template, each with its own mapping configuration.

## Configuration

| Setting | Description | Default |
| --- | --- | --- |
| **Event data key for items** | Event-data field containing the array to transform. | `items` |
| **Output type** | Choose **Array of values** or **Array of objects**. | `Array of objects` |
| **Source parameter for array of values** | Source item field to extract in values mode. Visible only in that mode. | `item_id` |
| **Item parameter mappings** | Mapping table with **Source item field** and **Output object key** columns. Visible only in objects mode. | No rows are preconfigured |

### Mode A: Array of values

Choose **Array of values** and enter a source parameter, for example `item_id`.

**Input event data:**

```json
{
  "items": [
    { "item_id": "16762_202102", "price": 50, "quantity": 2 },
    { "item_id": "98765_100200", "price": 20, "quantity": 1 }
  ]
}
```

**Output:**

```json
["16762_202102", "98765_100200"]
```

You can select any top-level field within each item, such as `price` or `quantity`. Its original value type is retained.

### Mode B: Array of objects

Choose **Array of objects** and add one row per field to the **Item parameter mappings** table.

| Source item field | Output object key |
| --- | --- |
| `item_id` | `id` |
| `price` | `item_price` |
| `quantity` | `quantity` |

Using the input above, the output is:

```json
[
  {
    "id": "16762_202102",
    "item_price": 50,
    "quantity": 2
  },
  {
    "id": "98765_100200",
    "item_price": 20,
    "quantity": 1
  }
]
```

The **Source item field** is the exact property name in the input item object. The **Output object key** is the property name to create in the output object. Mapping is direct: no dot-path parsing or nested-property lookup is implemented.

## Example destination configurations

These are example **variable outputs**. Your destination tag must place them into the correct request fields and structure.

| Use case | Output type | Configuration |
| --- | --- | --- |
| Meta `content_ids` | Array of values | Source: `item_id` |
| Meta `contents` | Array of objects | `item_id → id`, `quantity → quantity`, `price → item_price` |
| Pinterest product content objects | Array of objects | `item_id → id`, `price → item_price`, `quantity → quantity` |
| Criteo product ID list | Array of values | Source: `item_id` |
| Criteo product details | Array of objects | `item_id → id`, `price → price`, `quantity → quantity` |

For Meta Conversions API, the generated values may be assigned to the appropriate `custom_data` fields, subject to the tag's interface. For Pinterest and Criteo, check the specific integration and event schema before using the output. **Catalog product IDs must match the IDs expected by the destination platform.**

**Important:** GTM variables expose a built-in **Format Value** section. Leave additional formatting disabled when you need the returned arrays and objects unchanged.

## Permissions and implementation

The template uses these server-side sandbox APIs:

- `getEventData` to read the configured event-data key.
- `getType` to check whether the input and mappings are arrays or objects.

It requires **Read Event Data** permission, configured in the supplied `.tpl` for access to all event data. Review this scope against your organization's security requirements.

## License

No license is included with this README. Add a `LICENSE` file if you intend to specify reuse and distribution terms for the GitHub repository.
