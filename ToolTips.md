---
title: Pages Overview | BCLS24
---

# Pages Overview

## Pages

### Azure File Service Setup

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Storage Account | Specifies the value of the Storage Account field. |
| Field | File Share | Specifies the value of the File Share field. |
| Field | Sas Token | Specifies the value of the Sas Token field. |
| Field | Folder | Specifies the value of the Azure Folder field. |
| Field | Processed Folder | Specifies the value of the Azure Processed Folder field. |
| Action | Read Files | Read files from azure file share |
| Action | Import from Azure File Service | This Action will import the data from Azure File Service |
| Action | Import & Process payroll file | Import & Process payroll file |
| Action | what is my token | Executes the what is my token action. |

### ErrorCollection

| Type | Caption | Description |
| ----- | --------- | ------- |
| Action | TestError | Testing of collection of errors |

### Import Gen. Jnl Lines

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Line No. | Specifies the value of the Line No. field. |
| Field | Field_01 | Specifies the value of the Field_01 field. |
| Field | Field_02 | Specifies the value of the Field_02 field. |
| Field | Field_13 | Specifies the value of the Field_13 field. |
| Field | Field_03 | Specifies the value of the Field_03 field. |
| Field | Field_04 | Specifies the value of the Field_04 field. |
| Field | Field_14 | Specifies the value of the Field_14 field. |
| Field | Field_15 | Specifies the value of the Field_15 field. |
| Field | Field_05 | Specifies the value of the Field_05 field. |
| Field | Field_06 | Specifies the value of the Field_06 field. |
| Field | Field_07 | Specifies the value of the Field_07 field. |
| Field | Field_08 | Specifies the value of the Field_08 field. |
| Field | Field_09 | Specifies the value of the Field_09 field. |
| Field | Field_10 | Specifies the value of the Field_10 field. |
| Field | Field_11 | Specifies the value of the Field_11 field. |
| Field | Field_12 | Specifies the value of the Field_12 field. |
| Action | Conversion | Executes the Caption action. |

### Import Gen Jnl Conversion

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Entry No. | Specifies the value of the Entry No. field. |
| Field | Table ID | Specifies the value of the Table ID field. |
| Field | Table Name | Specifies the value of the Table Name field. |
| Field | Field No. | Specifies the value of the Field No. field. |
| Field | Field Name | Specifies the value of the Field Name field. |
| Field | Value | Specifies the value of the Value field. |
| Field | New Value | Specifies the value of the New Value field. |

### Subrat Worksheet

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Item Category Code Filter | Specifies the item category code to filter the items. |
| Field | LSC Division Code Filter | Specifies the division code to filter the items (for example Food, Hardware, Clothing). |
| Field | No. | Specifies the number of the item. |
| Field | Item Category Code | Specifies the item category code of the item. |

### IntrastatPurchaseListPAge

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Amount | Specifies the value of the Amount field. |
| Field | Area | Specifies the value of the Area field. |
| Field | Country Code | Specifies the value of the Country Code field. |
| Field | Country of Origin Code | Specifies the value of the Country of Origin Code field. |
| Field | Date | Specifies the value of the Date field. |
| Field | Document No. | Specifies the value of the Document No. field. |
| Field | Entry Point | Specifies the value of the Entry Point field. |
| Field | Exported to Sales Subs. | Specifies the value of the Exported to Sales Subs. field. |
| Field | Line No. | Specifies the value of the Line No. field. |
| Field | Partner VAT ID | Specifies the value of the Partner VAT ID field. |
| Field | Posted Document No. | Specifies the value of the Posted Document No. field. |
| Field | Processed | Specifies the value of the Processed field. |
| Field | Quantity | Specifies the value of the Quantity field. |
| Field | Statistical Value | Specifies the value of the Statistical Value field. |
| Field | Supplementary Units | Specifies the value of the Supplementary Units field. |
| Field | Synchronization Date Export | Specifies the value of the Synchronization Date Export field. |
| Field | Synchonization date import | Specifies the value of the Synchonization date import field. |
| Field | Synchonization time export | Specifies the value of the Synchonization time export field. |
| Field | Synchonization time import | Specifies the value of the Synchonization time import field. |
| Field | Tariff No. | Specifies the value of the Tariff No. field. |
| Field | Tariff No. Description | Specifies the value of the Tariff No. Description field. |
| Field | Total Weight | Specifies the value of the Total Weight field. |
| Field | Transaction Specification | Specifies the value of the Transaction Specification field. |
| Field | Transaction Type | Specifies the value of the Transaction Type field. |
| Field | Transport Method | Specifies the value of the Transport Method field. |
| Field | Type | Specifies the value of the Type field. |
| Field | Unit of Measure | Specifies the value of the Unit of Measure field. |
| Action | Process | Process action will help to insert the line into TCOG Tables |

## Page Extensions

### LSC Retail Item Card

| Type | Caption | Description |
| ----- | --------- | ------- |

### Purchase Invoice

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | VAT Base Discount % | VAT Base Discount % |

### Review G/L Entries

| Type | Caption | Description |
| ----- | --------- | ------- |
| Field | Debit (LCY) | Specifies the accumulated debit amount of all the lines applied to this line. |
| Field | Credit (LCY) | Specifies the accumulated credit amount of all the lines applied to this line. |
| Field | Balance | Specifies the accumulated balance of all the lines applied to this line. |
| Action | Set selected as reviewed | This action can only be selected when the G/L Account's Review Policy is either "Review Allowed" or "Review Allowed and Match Balance". For selected G/L Entries, field Reviewer is set to the current user, field Review Status is set to Reviewed, field Reviewed On is set to current date, field Review Id is to a number which all the marked entries share |
| Action | Set selected as not reviewed | This action can only be selected when the G/L Account's Review Policy is either "Review Allowed" or "Review Allowed and Match Balance". For selected G/L Entries, field Reviewer is set to blank, field Review Status is set to Not Reviewed, field Reviewed On is set to blank, field Review Id is to blank |
| Action | Select/Deselect | Select G/L Entries for further processing. |
| Action | Deselect All | Deselect G/L Entries. |

### Sales Order

| Type | Caption | Description |
| ----- | --------- | ------- |
| Action | Test Dimensions | Auto Insert of Dimension |
