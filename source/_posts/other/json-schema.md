json schema 用于规范约束 json 的格式

[官网](https://json-schema.org/)
[示例](https://json-schema.org/understanding-json-schema/index.html)
[rfc](http://json-schema.org/latest/json-schema-validation.html)

# 主要关键字
- $schema
- $id
- type
- description
- title
- required
- definitions

# 类型
## 对象
`"type": "object"`
### keywords
- maxProperties
- minProperties
- required
- properties
- patternProperties
- additionalProperties
- dependencies
- propertyNames
## 数组
`"type": "array"`
### keywords
- items
- additionalItems
- maxItems
- minItems
- uniqueItems
- contains
## 数字
### keywords
- multipleOf
- maximum
- exclusiveMaximum
- minimum
- exclusiveMinimum
## 字符串
### keywords
- maxLength
- minLength
- pattern

# 逻辑
- allOf
- anyOf
- oneOf
- not

# 其他
- definitions
