**TradeTidy: a CITES trade data formatting tool**



This tool standardises CITES trade data downloaded from the CITES Trade Database in comparative tabulation format. It ensures that reported trade in CITES‑listed taxa is comparable across time and can be meaningfully analysed. The tool accepts both comma‑ and semicolon‑separated outputs.



**Background:**

The CITES Trade Database (https://trade.cites.org/) is the most comprehensive and authoritative database on international trade in wildlife. It reflects the official trade records reported by Parties to the Convention on International Trade in Endangered Species of Wild Fauna and Flora (CITES), which aims to ensure that international trade in animals and plants does not threaten the survival of the species in the wild. The CITES Trade Database is managed by UNEP-WCMC on behalf of the CITES Secretariat. 



CITES trade data includes information on:

* Taxon (species, subspecies, or higher taxa)
* Exporter, importer, and country/ territory of origin where relevant
* Trade term (e.g. live, skins, meat, derivatives)
* Quantity
* Unit (e.g. number of specimens (NAR), kilograms)
* Purpose and source codes
* Year of trade



When downloaded, the raw comparative tabulation format may contain redundant units and trade terms (see https://tradeview.cites.org/en/methods for more information), or mixed reporting of either weight or volume for certain taxa. These inconsistencies make it difficult to analyse trends or compare trade directly. This tool was therefore designed to assist in the standardising of CITES trade data to allow easier analysis.






**How to Use the Tool**

1. Upload your comparative tabulation ('comptab') file as downloaded from the [CITES Trade Database](https://trade.cites.org/). Note that the tool accepts files in CSV format only; this is the default format downloaded from the database. 
2. Select all relevant formatting options from the right-hand list. These can be applied by selecting all relevant sliders, and information on each option can be found in tooltips. Note that some options will remain greyed out until dependent options are selected.
3. Once all formatting options have been selected, press 'convert to formatted data'. This will apply all formatting options together. Note that additional columns will have been created in your formatted file. This includes columns with written country/territory names for exporter, importer, and origin, and columns for converted units, terms, and quantities that resulted from associated formatting options above.
4. Finally, select 'download formatted data' to download and save your processed file.



**Further Information**

Full details of term and unit conversions can be found in [CITES Wildlife TradeView](https://tradeview.cites.org).



The user guide for the CITES Trade Database can be found [here](https://trade.cites.org/cites_trade_guidelines/en-CITES_Trade_Database_Guide.pdf).



**Citation**

UNEP‑WCMC (2026). TradeTidy: a CITES trade data formatting tool. Version 1.0. https://wcmc.io/TradeTidy.



**Disclaimer**

The geographical designations employed and the presentation of material in the tool’s outputs do not imply the expression of any opinion whatsoever on the part of the compilers concerning the legal status of any country, territory, city or area, or any of its authorities, or concerning the delimitation of its frontiers or boundaries.

