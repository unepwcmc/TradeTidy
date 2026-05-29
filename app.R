## THE REPORT DATA HANDLER ##

# ABOUT ####

# Select 'Run App' at the top right of the script window to use the app.  

# LOAD PACKAGES --------

if (!require("pacman")) install.packages("pacman")

pacman::p_load("shiny","tidyverse", "readr", "reshape2","shinythemes","shinyjs","bslib","shinyBS","bsicons", "shinybusy")


# DEFINE UI CARDS --------

# Switch labels

swtch1 <- input_switch("switch1", label = "Add taxonomic group (e.g. birds, mammals, etc)", FALSE)


swtch2 <- div(id = "switch2_wrapper",
              style = "display: flex; align-items: flex-start;",
                     div(style = "margin-right: 6px;",
                         input_switch(
                           id = "switch2",
                           label = NULL,
                           value = FALSE,
                           width = "auto")),
                     tags$div(class = "switch2-label",
                              style = "margin-top: 2px;",
                              "Standardise current terms and units",
                              popover(trigger = bs_icon("info-circle"),
                                      placement = "right",
                                      (HTML('Standardises CITES trade terms to current and taxon-specific terms (excluding coral and timber, which have additional quantity conversion factors applied)
                                            and converts trade reported in units of measure to standardised units (m, m2, m3, kg and l). 
                                            See <a href="https://tradeview.cites.org/en/methods" target="_blank" rel="noopener noreferrer">CITES Wildlife TradeView</a> for full details.')))))
                       
ConvertList_label <- popover(trigger = list("Apply additional taxon-specific conversion factor to:",
                                            bs_icon("info-circle")),
                             placement = "right",
                             (HTML('<b>Timber</b>: Converts trade in timber, sawn wood, and logs reported by weight to volume for species included in the CITES ID manual.
                             <b>Corals</b>: Converts live coral reported by weight to number of specimens, and raw coral reported by number of specimens to weight. 
                             Based on <em>Green & Shirley. 1999. The global trade in corals.</em>
                             See <a href="https://tradeview.cites.org/en/methods" target="_blank" rel="noopener noreferrer">CITES Wildlife TradeView</a> for full details.
                            <p>If you selected Coral and/or Timber from the dropdown and wish to remove your selection, use the backspace button.')))



swtch3 <- div(id = "switch3_wrapper",
              style = "display: flex; align-items: flex-start;",
              div(style = "margin-right: 6px;",
                  input_switch(
                    id = "switch3",
                    label = NULL,
                    value = FALSE,
                    width = "auto")),
              tags$div(class = "switch3-label",
                       style = "margin-top: 2px;",
                       "Replace blank units with 'number of specimens'",
                       popover(trigger = bs_icon("info-circle"),
                               placement = "right",
                               "Prior to the publication of revised 'Guidelines for the preparation and submission of CITES annual reports' in May 2021, 
  the unit of measure ‘number of specimens’ was reported as ‘no.’ or ‘blank’, and was represented as ‘blank’ in the CITES Trade Database. 
  It is therefore recommended to consider both unit ‘blank’ (particularly for historical data) and unit ‘NAR’ collectively as ‘number of specimens’ during trade data analysis.")))


# Button card

button.card <- card(
  id = "button_card", # added for reset button
  card_header("File processing"),
  fileInput(
    inputId = "dat_file",
    label = " ",
    buttonLabel = list(icon("upload"),"1. Upload CITES trade data"),
    width = "100%"
  ),
  disabled(actionButton("dat_convert", label = list(icon("rotate"),"2. Convert to formatted data"))),
  downloadButton("dat_download", label = "3. Download formatted data", class = "btn-success"),
  div(
    style = "text-align: right;",
    actionButton("resetAll", strong("Reset"), width = "20%")
  ),
)


# Option card

## adds popover / clickable tooltip
## separate switch labels from switch - coded above and wrapped in div to keep label and switch together

option.card <- card(
  id = "option_card", # added for reset button
  card_header("Formatting options"),
  
  swtch1, # taxonomic groups
  swtch2, # standardise terms
  
  selectInput("Conversion_lst", label = ConvertList_label, list("Corals" = "Corals_convert", "Timber" = "Timber_convert"), 
              multiple = TRUE),
  
  swtch3 # convert blanks
)



# USER INTERFACE --------

# The ui.R below defines the user interface for the CITES data processor Shiny App.
# The navbarPage function builds the Shiny App as a navigable tool, with one tab providing an "Introduction" and the other the main Processor.

ui <- page_fillable(
  
  ## to grey out selectInput label and swtch2 and swtch3 popover labels
  tags$style(HTML(".disabled-label {color: #adb5bd; opacity: 0.8;}")),
  
  ## makes it clear the page is working with loading symbol
  add_busy_spinner(spin = "fading-circle"),
  
  useShinyjs(), # To enable extra enable/disable button and option functionality hiding behaviour
  theme = bs_theme(version = 5), # This ensures compatibility isn't broken if the bslib package updates its default theme at a later date
  title = "TradeTidy: a CITES trade data formatting tool",
  
  titlePanel(tags$div("TradeTidy: a CITES trade data formatting tool",
                      style = "color:#34495e; font-size:32px; font-weight:700;")),
  layout_columns(
    button.card, option.card),
  card(card_header("Tool guide"),
       h6("This tool is intended to standardise ", strong("CITES trade data"), "downloaded from the ",
          tags$a(href="https://trade.cites.org/#", "CITES Trade Database", target = "blank"), "in comparative tabulation format to ensure that the reported trade in CITES-listed taxa is comparable across time and can be meaningfully analysed. It will work on both comma and semicolon separated outputs."),
       h6(strong("To use the tool:")),
       h6("1. Upload your comparative tabulation ('comptab') file as downloaded from the CITES Trade Database.", em("Note that the tool accepts files in CSV format only; this is the default format downloaded from the database.")),
       h6("2. Select all relevant formatting options from the right-hand list. These can be applied by selecting all relevant sliders,
       and information on each option can be found in tooltips.", em(" Note that some options will remain greyed out until dependent options are selected.")),
       h6("3. Once all formatting options have been selected, press 'convert to formatted data'. This will apply all formatting options together.", em ("Note that additional columns will have been created in your formatted file. This includes columns with written country/territory names for exporter, importer, and origin, and columns for converted units, terms, and quantities that resulted from associated formatting options above.")),
       h6("4. Finally, select 'download formatted data'."),
        h6(HTML('Full details of term and unit conversions can be found in <a href="https://tradeview.cites.org/en/methods" target="_blank" rel="noopener noreferrer">CITES Wildlife TradeView</a>, 
               and the user guide for the CITES Trade Database can be found <a href="https://trade.cites.org/cites_trade_guidelines/en-CITES_Trade_Database_Guide.pdf" target="_blank" rel="noopener noreferrer">here</a>.')),
       h6("Citation: UNEP-WCMC (2026). TradeTidy: a CITES trade data formatting tool. Version 1.0. [wcmc.io URL]."),
       h6(em("The geographical designations employed and the presentation of material in the tool's outputs do not imply the expression of any opinion whatsoever on the part of the compilers concerning the legal status of any country, territory, city or area,
       or any of its authorities, or concerning the delimitation of its frontiers or boundaries."))
  ))




# SERVER --------

server <- function(input, output, session) {
  
  session$onFlushed(function() {
    shinyjs::disable("dat_download")
  }, once = TRUE)
  
  
  disable("switch1")
  
  disable("switch2")
  runjs("$('#switch2_wrapper .switch2-label').addClass('disabled-label');")
  
  disable("Conversion_lst")
  runjs("$('#Conversion_lst').closest('.form-group').find('label').addClass('disabled-label');") # greys out label (select input works differently to switches and label doesn't grey automatically)
  
  disable("switch3")
  runjs("$('#switch3_wrapper .switch3-label').addClass('disabled-label');")
  
  # set upload limit to 30MB
  
  options(shiny.maxRequestSize=3000*1024^2)
  
  # create empty values objects
  
  values <- reactiveValues(DAT=NULL)
  values_2 <- reactiveValues(DAT=NULL)
  values_preconversion <- reactiveValues(DAT=NULL) # Used later to save a static copy of the unconverted dataset
  values_preconversion_2 <- reactiveValues(DAT=NULL) # Used later to save a static copy of the unconverted dataset
  
  
  
  # input file preparation  --------
  
  # Upload button logic
  # assume comma-separated file type first, if this fails (all rows combined in 1 column) treat as semicolon separated
  
  observeEvent(input$dat_file, {
    df <- read.csv(input$dat_file$datapath, stringsAsFactors = FALSE, na.strings = "Nope") # assume comma-separated
    
    if (ncol(df) == 1 && any(grepl(";", df[[1]]))) { # if only one column, read as semicolon separated
      df <- read.csv2(input$dat_file$datapath, stringsAsFactors = FALSE, na.strings = "Nope")  
      
      # read.csv2 expects semicolon separator to have "," as decimal and will break if "." is used.
      # if decimal separator is "." then force using read.table
      if (any(grepl("\\.", readLines(input$dat_file$datapath, n = 5)))) {
        df <- read.table(input$dat_file$datapath, header = TRUE, sep = ";", dec = ".", stringsAsFactors = FALSE, na.strings = "Nope")
      }
    }
    
    values$DAT <- df
    
    # set up row ID for future matching
    values_2$TEMP <- df
    values_2$TEMP$No <- 1:nrow(values_2$TEMP) 
    values$DAT$No <- 1:nrow(values$DAT)

    

    # correct for purpose T = TRUE and source F = FALSE
    
    values$DAT$Purpose[values$DAT$Purpose == "TRUE"] <- "T"
    values$DAT$Source[values$DAT$Source == "FALSE"] <- "F"
    
    # when all rows = blank, contents are changed to NA.
    # turn back to blank for unit, source, purpose and Class
    
    cols <- c("Unit", "Source", "Purpose", "Class")
    values$DAT[cols][is.na(values$DAT[cols])] <- ""
    
    
    # to retain columns in correct order - set vector of colnames
    # this will be used below
    
    DATcolnames_order <- colnames(values$DAT)
    
    # add country names according to country code for import, export, and origin columns
    
    Country.names<-read.csv("InputData/Country_names.csv",na.strings="Nope")
    
    # EXPORTER    
    names(values$DAT)[names(values$DAT) == "Exporter"] <- "Exporter_ISO2"
    values$DAT$Exporter <- Country.names$Official_name[match(values$DAT$Exporter_ISO2, Country.names$ISO)]
    
    # IMPORTER
    names(values$DAT)[names(values$DAT) == "Importer"] <- "Importer_ISO2"
    values$DAT$Importer <- Country.names$Official_name[match(values$DAT$Importer_ISO2, Country.names$ISO)]
    
    # ORIGIN
    names(values$DAT)[names(values$DAT) == "Origin"] <- "Origin_ISO2"
    values$DAT$Origin <- Country.names$Official_name[match(values$DAT$Origin_ISO2, Country.names$ISO)]
    
    
    # if origin = NA, replace with blank 
    levels(values$DAT$Origin) <- c(levels(values$DAT$Origin),"")
    values$DAT$Origin[values$DAT$Origin %in% c(NA,"NA")] <- ""
    
    
    # melt reporter-type quantity columns to allow for more streamlined conversions
    
    values$DAT <- melt(values$DAT,id=c("Year","App.","Taxon","Class","Order","Family","Genus","Importer","Exporter","Origin","Exporter_ISO2", "Importer_ISO2", "Origin_ISO2","Term","Unit","Purpose","Source", "No"))
    names(values$DAT)[names(values$DAT) == "variable"] <- "Reporter.Type"
    names(values$DAT)[names(values$DAT) == "value"] <- "Quantity"
    
    
    # add updated fields - by default populated with data as per CITES Trade Database
    
    values$DAT$Quantity_converted <- as.numeric(as.character(values$DAT$Quantity))
    values$DAT$Term_converted <- values$DAT$Term
    values$DAT$Unit_converted <- values$DAT$Unit
    
    
    # enable non-conditional options following the upload
    
    enable("dat_convert")
    
    enable("switch1")
    
    enable("switch2")
    runjs("$('#switch2_wrapper .switch2-label').removeClass('disabled-label');")
    
    enable("switch3")
    runjs("$('#switch3_wrapper .switch3-label').removeClass('disabled-label');")
    
    
    # Disable the download button any time a new file is uploaded
    
    disable("dat_download")

    
    # Save a static snapshot of the unconverted data
    
    values_preconversion$DAT <- values$DAT
    values_preconversion_2$DAT <- values_2$DAT
  })
  
  
  
  # Condition option logic --------
  
  # Conditionally enable and disable options with interdependencies
  
  observeEvent(input$switch2, {
    if(input$switch2 == FALSE){
      
      disable("Conversion_lst")
      runjs("$('#Conversion_lst').closest('.form-group').find('label').addClass('disabled-label');") # greys out label
      
      reset("Conversion_lst")
      
    } else {
      enable("Conversion_lst")   
      runjs("$('#Conversion_lst').closest('.form-group').find('label').removeClass('disabled-label');") #changes text colour back to black
      
    }
  })
  
  
  # Disable the download button any time an option is changed
  
  observeEvent(input$switch1, {
    disable("dat_download")
    })
  
  observeEvent(input$switch2, {
    disable("dat_download")
  })
  
  observeEvent(input$Conversion_lst, {
    disable("dat_download")
  })
  
  
  observeEvent(input$switch3, {
    disable("dat_download")
  })
  
  
  # Convert button logic  --------
  
  observeEvent(input$dat_convert, {
    
    # Reset values to preconversion baseline
    values$DAT <- values_preconversion$DAT
    values_2$DAT <- values_preconversion_2$DAT
    
    
    
    # (1) Groups --------
    if(input$switch1 == TRUE){
      
      GD <- read.csv("InputData/Taxonomic_groups.csv")
      
      gd_clean <- GD[!GD$TaxonName == "", ] #excludes class = blank (plants, accounted for at the end)
      
      # match group by class then loop sequentially through the rest of the taxonomic levels
      # taxon = accepted taxon name (mainly species, but will also include trade reported >class)
      values$DAT$Group <- gd_clean$Group[match(values$DAT$Class, gd_clean$TaxonName)]
      
      ranks <- c("Order", "Family", "Genus", "Taxon")
      
      for (rank in ranks) {
        missing <- is.na(values$DAT$Group)
        if (!any(missing)) break  # Stop early if everything is matched
        
        values$DAT$Group[missing] <- GD$Group[match(values$DAT[[rank]][missing], GD$TaxonName)]
      }
      
      values$DAT$Group[is.na(values$DAT$Group)] <- "Plants" # remaining blanks assumed to be plants 
      
    }
    
    
    
    # (2) Terms --------
    if(input$switch2 == TRUE){
      
      # standardise terms
      
      # Deletes UNIT = "pairs" and multiplies by 2
      values$DAT$Quantity_converted[values$DAT$Unit_converted %in% c("pairs")] <- (values$DAT$Quantity_converted[values$DAT$Unit_converted %in% "pairs"])*2
      values$DAT$Unit_converted[values$DAT$Unit_converted %in% "pairs"] <- "Number of specimens"
      
      # Deletes obsolete unit code and replaces them with 'Number of specimens' (formerly was blank "")
      values$DAT$Unit_converted[values$DAT$Unit_converted %in% c("items","pieces","cartons","bags","bottles","cans","boxes","sets","cases","flasks","shipments","(skins)")] <- "Number of specimens"
      
      # Converts obsolete term codes
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("shoes","leather items","leather")] <- "leather products (small)"
      values$DAT$Term_converted[values$DAT$Term_converted %in% "skin scraps"] <- "skin pieces"
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("timber carvings","wood products")] <- "wood product"
      values$DAT$Term_converted[values$DAT$Term_converted %in% "scraps"] <- "derivatives"
      values$DAT$Term_converted[values$DAT$Term_converted %in% "spectacle frames"] <- "carving"
      
      # Converts furniture to wood product or carving
      GD2 <- read.csv("InputData/Taxonomic_groups.csv")
      
      t_tim <- GD2$TaxonName[GD2$Group == "Timber"]
      
      values$DAT$Term_converted <- ifelse(values$DAT$Term_converted %in% "furniture",
                                          ifelse(values$DAT$Genus %in% c(t_tim) | values$DAT$Taxon %in% (t_tim),
                                                 "wood product", "carving"),
                                          values$DAT$Term_converted)
      
      # Converts term 'sets of piano keys' to 'ivory carvings' and multiplies quantity by 52
      values$DAT$Quantity_converted[values$DAT$Term_converted %in% "sets of piano keys"] <- (values$DAT$Quantity_converted[values$DAT$Term_converted %in% "sets of piano keys"])*52
      values$DAT$Term_converted[values$DAT$Term_converted %in% "sets of piano keys"] <- "piano keys (worked ivory)"
      
      # Converts metric and non-metric units
      conv_lookup <- data.frame(
        Unit_original = c("microgrammes", "mg", "g", "tonne", "metric tonnes", 
                           "ml", "cm", "cm2", "dm2", "cm3", "inches", "yds", 
                           "ft2", "ft3", "oz", "lbs"),
        multiplier = c(1e-9, 1e-6, 1e-3, 1e3, 1e3, 
                           1e-3, 1e-2, 1e-4, 1e-2, 1e-6, 0.0254, 0.9144, 
                           0.092903, 0.0283168, 0.0283495, 0.453592),
        Unit_converted = c("kg", "kg", "kg", "kg", "kg", 
                           "l", "m", "m2", "m2", "m3", "m", "m", 
                           "m2", "m3", "kg", "kg"),
        stringsAsFactors = FALSE
      ) # create lookup table
      
      unit_idx <- match(values$DAT$Unit_converted, conv_lookup$Unit_original) 
      unit_match <- !is.na(unit_idx) # retain just rows using non-standard units (unit_original)
      
      if (any(unit_match)) {
        matched_lookup <- unit_idx[unit_match] # row index in conv_lookup
        values$DAT$Quantity_converted[unit_match] <- values$DAT$Quantity_converted[unit_match] * conv_lookup$multiplier[matched_lookup] # apply multiplier
        values$DAT$Unit_converted[unit_match] <- conv_lookup$Unit_converted[matched_lookup] # replace with updated units
      }
      
      # Converts units bellyskins, hornbacks and backskins to skins 
      # units converted to Number of specimens
      # for backskins ONLY quantity / 2
      values$DAT$Quantity_converted[values$DAT$Unit_converted %in% "backskins"] <- (values$DAT$Quantity[values$DAT$Unit_converted %in% "backskins"])/2
      
      values$DAT$Term_converted[values$DAT$Unit_converted %in% c("bellyskins","hornback skins", "backskins") & values$DAT$Term_converted == "skin pieces"] <- "skins"
      values$DAT$Unit_converted[values$DAT$Unit_converted %in% c("bellyskins","hornback skins", "backskins") & values$DAT$Term_converted %in% c("skins","skin pieces")] <- "Number of specimens"
      
      # Converts sides (term and unit) to skins and divides quantity by two
      values$DAT$Quantity_converted[values$DAT$Unit_converted %in% "sides"] <- (values$DAT$Quantity[values$DAT$Unit_converted %in% "sides"])/2
      values$DAT$Quantity_converted[values$DAT$Term_converted %in% "sides" & values$DAT$Unit_converted %in% c("Number of specimens", "")] <- (values$DAT$Quantity[values$DAT$Term_converted %in% "sides"& values$DAT$Unit_converted %in% c("Number of specimens", "")])/2
      values$DAT$Unit_converted[values$DAT$Unit_converted %in% "sides"] <- "Number of specimens"
      values$DAT$Term_converted[values$DAT$Term_converted %in% "sides"] <- "skins"
      
      # Converts shells to carapaces for Testudines
      values$DAT$Term_converted[values$DAT$Term_converted %in% "shells" & values$DAT$Order %in% "Testudines"] <- "carapaces"
      
      # Converts frog legs (kg) to meat (kg)
      values$DAT$Term_converted[values$DAT$Term_converted%in% "frog legs" & values$DAT$Unit_converted %in% "kg"] <- "meat"
      
      # Converts sturgeon eggs to caviar and converts sturgeon derivatives to extra
      values$DAT$Term_converted[values$DAT$Order %in% "Acipenseriformes" & values$DAT$Term_converted %in% "eggs"] <- "caviar"
      values$DAT$Term_converted[values$DAT$Order %in% "Acipenseriformes" & values$DAT$Term_converted %in% "derivatives"] <- "extract"
      
      # Converts roots to live for Genus = Galanthus, Cyclamen and Sternbergia
      values$DAT$Term_converted[values$DAT$Term_converted %in% "roots" & values$DAT$Genus %in% c("Galanthus","Cyclamen","Sternbergia")] <- "live"
      
      # Converts derivatives and powder to extract for Aloes and Euphorbias
      values$DAT$Term_converted[values$DAT$Term_converted%in% c("derivatives","powder") & values$DAT$Genus %in% c("Aloe","Euphorbia")] <- "extract"
      
      # Converts timber pieces -> timber
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("timber pieces")] <- "timber"
      values$DAT$Term_converted<-as.character(values$DAT$Term_converted)
      
      # Converts bone products to bone carvings
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("bone products")] <- "bone carving"
      
      # Converts horn scraps to horn pieces
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("horn scraps")] <- "horn pieces"
      
      # Converts ivory scraps to ivory pieces
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("ivory scraps")] <- "ivory pieces"
      
      # Converts quills to feathers (only aves)
      values$DAT$Term_converted[values$DAT$Term_converted %in% "quills" & values$DAT$Class %in% "Aves"] <- "Feather"
      
      # Converts venom to extract
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("venom")] <- "extract"
      
      # Converts heads to skull
      values$DAT$Term_converted[values$DAT$Term_converted %in% c("heads")] <- "skull"
      
    }
    
    
    
    # (Conversion_lst) Coral --------
    if("Corals_convert" %in% input$Conversion_lst){
      
      # coral conversions
      #Term	                Converted to	        Conversion factor
      #live corals (kg)	    live corals (pieces)	/206.1g
      #raw corals (pieces)	raw corals (kg)	      *580g
      
      # dependent on group = coral, so to allow this to work independent of the 'add group' button
      # apply rule if the class matches the taxon name for group coral in the 'taxon groups' read in then perform conversion ---
      GD3 <- read.csv("InputData/Taxonomic_groups.csv")
      
      t_cor <- GD3$TaxonName[GD3$Group == "Coral"]
      
      values$DAT$Quantity_converted <- ifelse(values$DAT$Class %in% c(t_cor) & values$DAT$Term_converted == "live" & 
                                                values$DAT$Unit_converted == "kg", 
                                              values$DAT$Quantity_converted/0.206, values$DAT$Quantity_converted)
      
      values$DAT$Unit_converted[values$DAT$Class %in% c(t_cor) & values$DAT$Term_converted == "live" & 
                                  values$DAT$Unit_converted == "kg"] <- "Number of specimens"
      
      
      values$DAT$Quantity_converted <- ifelse(values$DAT$Class %in% c(t_cor) & values$DAT$Term_converted == "raw corals" & 
                                                values$DAT$Unit_converted %in% c("", "Number of specimens"), 
                                              values$DAT$Quantity_converted*0.580, values$DAT$Quantity_converted)
      
      values$DAT$Unit_converted[values$DAT$Class %in% c(t_cor) & values$DAT$Term_converted == "raw corals" & 
                                  values$DAT$Unit_converted %in% c("", "Number of specimens")] <- "kg"
      
      
    }
    
    
    
    # (Conversion_lst) Timber --------
    if("Timber_convert" %in% input$Conversion_lst){
      
      # timber conversions
      # Converts kg of timber to m3 for taxa where a conversion factor is available
      
      timber_terms <- c("timber", "sawn wood", "logs")
      
      timber_conversions <- c(
        "Pericopsis elata"      = 725,  "Cedrela odorata"       = 440,
        "Guaiacum sanctum"      = 1230, "Guaiacum officinale"   = 1230,
        "Swietenia macrophylla" = 730,  "Swietenia humilis"     = 610,
        "Swietenia mahagoni"    = 750,  "Araucaria araucana"    = 570,
        "Fitzroya cupressoides" = 480,  "Dalbergia nigra"       = 970,
        "Abies guatemalensis"   = 350,  "Prunus africana"       = 740,
        "Gonystylus spp."       = 660,  "Gonystylus"            = 660
      )
      
        is_timber_kg <- values$DAT$Term_converted %in% timber_terms & values$DAT$Unit_converted == "kg" #subset by relevant terms/unit
    
      if (any(is_timber_kg)) {
        
        taxon_match <- match(values$DAT$Taxon[is_timber_kg], names(timber_conversions))
        genus_match <- match(values$DAT$Genus[is_timber_kg], names(timber_conversions)) # match sequentially by taxon then genus

        cf_idx <- ifelse(!is.na(taxon_match), taxon_match, genus_match)
        cf_match <- !is.na(cf_idx) # only instances where a conversion factor would be applied
        
        if (any(cf_match)) {
          rows_to_update <- which(is_timber_kg)[cf_match]
          conversion_factor <- timber_conversions[cf_idx[cf_match]]
          
          values$DAT$Unit_converted[rows_to_update] <- "m3"
          values$DAT$Quantity_converted[rows_to_update] <- values$DAT$Quantity_converted[rows_to_update] / conversion_factor
        }
      }
    }

    
    # (3) Blank to NAR --------
    if(input$switch3 == TRUE){
      # convert blank unit to NAR ('Number of specimens')
      # NB changing old units (eg sides) to 'Number of specimens' done above
      # NB this does NOT do any further aggregating
      
      # if there is a unit_converted column, apply to unit_converted, else use the original reported unit column
      # this prevents it overwriting any other unit_converted rules applied to blank unit above
      
      if(!length(values$DAT$Unit_converted)==0)
      {
        values$DAT$Unit_converted[values$DAT$Unit_converted %in% ""] <- "Number of specimens"
      }
      else
      {
        values$DAT$Unit_converted <- values$DAT$Unit
        values$DAT$Unit_converted[values$DAT$Unit %in% ""] <- "Number of specimens"
      }
    }
    
    
    
    # Reorder columns --------
    # to run automatically after all the formatting options have been selected

          # order columns
      
      columns<-names(values$DAT)
      
      if(!length(values$DAT$Group)==0)
        {
          values$DAT <- reshape2::dcast(values$DAT,Year + App. + Taxon + Group + Class + Order + Family + Genus +
                              Importer + Importer_ISO2 + Exporter + Exporter_ISO2 + Origin + Origin_ISO2 +
                              Term + Term_converted + Unit + Unit_converted + Purpose + Source + No ~ 
                              Reporter.Type,value.var="Quantity_converted")
        }
        else
        {
          values$DAT <- reshape2::dcast(values$DAT,Year + App. + Taxon + Class + Order + Family + Genus +
                              Importer + Importer_ISO2 + Exporter + Exporter_ISO2 + Origin + Origin_ISO2 +
                              Term + Term_converted + Unit + Unit_converted + Purpose + Source + No ~ 
                              Reporter.Type,value.var="Quantity_converted")
        }
      
      values$DAT <- values$DAT[order(values$DAT$No),]
      names(values$DAT)[names(values$DAT) == "Importer.reported.quantity"] <- "Importer.reported.quantity_converted"
      names(values$DAT)[names(values$DAT) == "Exporter.reported.quantity"] <- "Exporter.reported.quantity_converted"
      values$DAT$Importer.reported.quantity <- values_2$TEMP$Importer.reported.quantity
      values$DAT$Exporter.reported.quantity <- values_2$TEMP$Exporter.reported.quantity
      
      values$DAT$No <- NULL
      
      values$DAT[is.na(values$DAT)] <- ""
      
      subset_cols <- c("Importer.reported.quantity", "Importer.reported.quantity_converted", "Exporter.reported.quantity", "Exporter.reported.quantity_converted")
      current_order <- names(values$DAT)
      current_order[current_order %in% subset_cols] <- subset_cols
      values$DAT <- values$DAT[, current_order]
    
    # Notification message  --------
    # TBD
    
      
    # Enable download button  --------
    enable("dat_download")
    
    showNotification( 
      paste("Data formatted successfully"), 
      duration = 3,
      closeButton = TRUE,
      type = "message"
    )
  })
  
  # Download button logic --------
  
  output$dat_download <- downloadHandler(
    filename = function() {
      paste0("FORMATTED_", input$dat_file$name)
    },
    content = function(file) {
      readr::write_excel_csv(values$DAT,file)
    })
  
  observeEvent(input$resetAll, {
    
    # reset all and disable formatting options
    
    disable("switch1")
    disable("switch2")
    runjs("$('#switch2_wrapper .switch2-label').addClass('disabled-label');")
    
    disable("Conversion_lst")
    runjs("$('#Conversion_lst').closest('.form-group').find('label').addClass('disabled-label');") # greys out label
    
    disable("switch3")
    runjs("$('#switch3_wrapper .switch3-label').addClass('disabled-label');")
    
    disable("dat_download")
    disable("dat_convert")
    
    reset("button_card")
    reset("option_card")
    
    values$DAT<-data.frame()
    
  })
  
  
  
  
  
}


## RUN APP

shinyApp(ui = ui, server = server)