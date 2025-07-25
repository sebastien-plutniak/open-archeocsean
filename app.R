library(shinythemes)
library(leaflet)
library(DT)
# library(htmltools)
# library(ggplot2)
# library(dplyr)
# library(plotly)


css <- '
.tooltip {
  pointer-events: none;
}
.tooltip > .tooltip-inner {
  pointer-events: none;
  background-color: #FFFFFF;
  color: #000000;
  border: 1px solid black;
  padding: 5px;
  font-size: 12px;
  text-align: left;
  max-width: 300px;
  content: <b>aa</b>;
}
.tooltip > .arrow::before {
  border-right-color: #73AD21;
}
'

js <- "
$(function () {
  $('[data-toggle=tooltip]').tooltip()
})
"



# DEFINE UI ----
ui <- shinyUI(  
  fluidPage(
    theme = shinytheme("cerulean"), 
    tags$head(
      tags$style(HTML(css)),
      tags$script(HTML(js))
    ),
    HTML("<div align=left>
             <h1>
             <a href=https://www.ocsean.eu/  target=_blank><img height='40px' src=logo-ocsean.jpg></a> 
         <i><a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank>Open-archeOcsean</a></i></h1>"
    ),
    # )),
    tabsetPanel(id="tabs",
                tabPanel("Home",  # : TAB home ----
                         fluidRow(
                           column(1),
                           column(3, align="center",
                                  tags$div(
                                    HTML(paste("<div style=width:90%;, align=left>
             <h2>Presentation</h2>
    <p>
      <i>Open-archeOcsean</i> is a curated catalogue of open-source resources regarding the archaeology of the Pacific and Southeasth Asia region, developped in the context of the  <a href=https://www.ocsean.eu/  target=_blank><i>Ocsean. Oceanic and Southeast Asian Navigators</i></a> project. 
    </p>
    <p>
    Textual descriptions of the resource are displayed either by clicking on the map or by hovering the mouse on the resource name in the table.
    
    Resources can be explored by:
               <ul>
               
                  <li> <b>Scope</b>:
                    <ul>
                      <li><i>Single site</i>: the resource regards one archaeological site, represented as a point on the map.</li>
                      <li><i>Multi sites</i>: the resource regards several archaeological sites, represented as surfaces on the map.</li>
                    </ul>
                  </li>
                  <li> <b>Access mode</b>:
                    <ul>
                      <li><i>Open</i>: the resource can be directly accessed using the provided link.</li>
                      <li><i>Restricted</i>: access to the resource must be requested using the provided link.</li>
                      <li><i>Embargoed</i>: access to the resource will be possible in the future.</li>
                    </ul>
                  </li>
                  <li> <b>Data structure</b>:
                    <ul>
                      <li><i>Dataset</i>: flat data structure (e.g., CSV, XLSX, PDF formats).</li>
                      <li><i>Database</i>: relational data structure (e.g., MySQL, Django, Access, etc.)</li>
                    </ul>
                  </li>
                  </ul>
                  In addition, use the “Search” field to retrieve resources by:
                                               <ul>",
                                               span(
                                                 `data-toggle` = "tooltip", `data-placement` = "bottom",
                                                 title = "bone, botanical, burial, eggshell, glass, lithic, organic tools, pottery, sediments, shell
                   ",
                                                 HTML("<li><b>Material</b>: using these <a href=>keywords</a>.</li>")),
                                               span(
                                                 `data-toggle` = "tooltip", `data-placement` = "bottom",
                                                 title = "granulometry, ICP-AES, isotopic, LA-ICP-MS, morphometrics, pXRF, radiocarbon, TL/OSL, TOC/TN, U/Th, XRD
                   ",
                                                 HTML("<li><b>Measurement and description method</b>: using these <a href=>keywords</a>.</li>")),
                  "
                     </ul>    
                    </p>
                    <p>
                      The data and app code source are available on <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a>.
                    </p>
                    </div>" )) # end html
                                  ), # end div
                           ), #end column
                  # <li> <b>Surface rank</b>: from the largest covered surface to the smallest. </li>
                           column(7, align="left", # 
                                 br(),
                                 leafletOutput("map", width="100%", height = 600), # : leaflet map  ----
                           ) # end column
                         ), #end fluidrow
                         fluidRow(align = "left",
                                  column(1),
                                  column(10,  align = "center",
                                         br(),
                                         "Click on a line to zoom the map on this resource",
                                         DT::dataTableOutput("table",  width="100%"), # : table output ----
                                         br(),
                                         downloadButton("download.table", "Download the data (CSV)"),
                                         br(),br(),br(),br()
                                  )  # end column
                         )# end fluidrow
                ), # end tabset
                tabPanel("Contribute", # : TAB contribute ----
                         fluidRow(column(1),
                                  column(7,
                                         tags$div(HTML("
                             <h2>Contact</h2>
                              Contribution are welcome and can be done:
                              <ul>
                               <li>either by writing to: sebastien.plutniak_at_cnrs.fr</li>
                               <li>or by creating an 'issue' or a 'pull request' on the <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank>github repository</a>. </li>
                              </ul>
               ") # end HTML
                                         ) # end div
                                  )    # end column
                         ) # end fluidrow
                ), #end tab
                tabPanel("Contributors & Credits ", # : TAB credits ----
                         fluidRow(column(1),
                                  column(7,
                                         tags$div(HTML("
                             <h2>Credits</h2>
                              <ul>
                              <li> The <i>open-archeOcsean</i> dataset and application are developed and maintained by <b>Sébastien Plutniak</b> (CNRS).</li>
                              <li> It benefited from the help of: Ethan Cochrane, Kristine Hardy, Mathieu Leclerc, Anna Pineda </li>
                </ul>
                 <h2>Support</h2>
                 <div style='text-align:left'>
                    <b> <i>open-archeOcsean</i></b>
                    <br><br>
                    <table> 
                      <tr>
                        <td> is supported by: &nbsp;  &nbsp; &nbsp; <br> <br> <a href=https://www.ocsean.eu/  target=_blank><img height='60px' src=logo-ocsean.jpg></a></td>
                        <td>is developped at: &nbsp; &nbsp; &nbsp;  <br> <br> <a href=https://www.cnrs.fr target=_blank><img height='60px' src=logo-cnrs.png></a></td>
                        <td>  is hosted by:  <br> <br> <a href=https://www.huma-num.fr/ target=_blank><img height='60px' src=logo-humanum.jpg></a></td>
                      </tr>
                    </table> 
                </div> 
               ") # end HTML
                                         ) # end div
                                  )    # end column
                         ) # end fluidrow
                ) #end tab
    ) # end tabsetpanel
  ) #endfluidPage
) #end  shinyUI



# DEFINE SERVER  ----    
server <- function(input, output, session) {
  # write to log
  # write.csv(rbind(log.df, cbind("date" = format(Sys.Date()), "instance" = basename(getwd()))), "../../archeoviz-log.csv", row.names = F)
  
  # data preparation  ----
  data <- read.csv("data/open-archeocsean-data.csv")
  sites <- data
  
  ## adapt negative longitude ----
  sites[which(sites$bbox.lon1 < 0), ]$bbox.lon1 <- 180 + (180 + sites[which(sites$bbox.lon1 < 0), ]$bbox.lon1)
  sites[which(sites$bbox.lon2 < 0), ]$bbox.lon2 <- 180 + (180 + sites[which(sites$bbox.lon2 < 0), ]$bbox.lon2)
  sites[which(sites$lon < 0), ]$lon <- 180 + (180 + sites[which(sites$lon < 0), ]$lon)
  
  ## area ----
  compute.area <- function(lon1, lon2, lat1, lat2){
    lon1 <- as.numeric(lon1)
    lon2 <- as.numeric(lon2)
    lat1 <- as.numeric(lat1)
    lat2 <- as.numeric(lat2)
    lon.max <- sort(c(lon1, lon2))[1]
    lon.min <- sort(c(lon1, lon2))[2]
    lat.max <- sort(c(lat1, lat2))[1]
    lat.min <- sort(c(lat1, lat2))[2]
    
    (lon.max - lon.min) * (lat.max - lat.min)
  }
  sites$area <- apply(sites, 1, function(x) compute.area(
                                           lon1 = x[which(names(sites) == "bbox.lon1")],
                                           lon2 = x[which(names(sites) == "bbox.lon2")], 
                                           lat1 = x[which(names(sites) == "bbox.lat1")],
                                           lat2 = x[which(names(sites) == "bbox.lat2")])
        )
  # areaPolygon
  
  # sites$area.rank <- order(sites$area)  # todo convert lat/lon en surface
  # sites[is.na(sites$bbox.lon1), ]$area.rank <- NA
  
  ## resource name and link ----
  sites$resource.name <- paste0("<a href=", sites$download_url, " title='", sites$description, "' target=_blank>", sites$name, "</a> ",
                          "<a href=", sites$info_url, " title='Click to access related documentation.' target=_blank><img height=12px src=icon-doc.jpg></a>")
  
  ## PID ----
  sites$pid <- "url"
  sites[grep("doi", sites$download_url), ]$pid <- "doi"
  sites[grep("hdl", sites$download_url), ]$pid <- "hdl"
  sites$pid <- factor(sites$pid )
  
  ## popup ----
  sites$tab.link <- paste0("<a href=", sites$download_url, " title='Click to access this resource' target=_blank>", sites$name, "</a>")
  sites$popup <- paste0("<b>", sites$tab.link, "</b><br>", 
                        sites$description, ".<br>",
                        "<b>Licence:</b> ", sites$licence, "<br>",
                        "<b>Access:</b> ", sites$access)
  
  sites <- sites[order(sites$name), ]
  sites$id <- 1:nrow(sites)
  
  sites$fillOpacity <- .2
  
  access.lvl <- c("open", "embargoed", "failing", "restricted")
  access.color <- c("darkgreen", "purple", "yellow", "red") 
  
  sites$color <- as.character(factor(sites$access, levels = access.lvl, labels =  access.color))
  sites$fillcolor <- "white"
  
  ## periods -----
  # sites$period <-  sites$period1
  # idx <- sites$period2 != ""
  # sites[idx, ]$period <- paste0(sites[idx, ]$period1,
  #                               " → ", sites[idx, ]$period2)
  
  ## 5 stars scale ----
  five.stars.score <- function(item, score){
    
    score <- as.numeric(score)
    
    res <- ""
    if(! is.na(score)){
      res <- paste0(c(
        "<div title='Score:", score, "'>",
              paste0(rep("<font  color='gold'>★</font>", score), collapse = ""),
              paste0(rep("<font color='LightGray'>★</font>", 5 - score), collapse = ""),
               "</div>"
              ),
             collapse = "")
    }
    res  
  }
  
  sites$five.stars.score.label <- apply(sites, 1, function(x) 
           five.stars.score(item = x, score = x[which(colnames(sites) == "five.stars.score")] ))
  
  
  sites$access <- factor(sites$access)
  sites$scope <- factor(sites$scope)
  sites$licence <- factor(sites$licence)
  sites$type <- factor(sites$type)
  sites$storage <- factor(sites$storage)
  
  
  # span(
  #   `data-toggle` = "tooltip", `data-placement` = "bottom",
  #   title = "Click to display a graph of the chronological periods included.",
  #   HTML("<a href=chronoGraph.jpg target=_blank>chronological period</a></b>"))
  
  # 
  idx <- grep("material", names(sites))
  sites$material.keywords <- apply(sites[, idx], 1, paste0, collapse = " ")
  
  idx <- grep("measurement_type", names(sites))
  sites$measurement.keywords <- apply(sites[, idx], 1, paste0, collapse = " ")
  

  
  
  # Table output ----
  output$table <- DT::renderDataTable({ 
    
    tab <- sites[ , c("resource.name",   "five.stars.score.label",  "scope", "access", "pid", "type", "date_publication", "date_last.update", "licence", "material.keywords", "measurement.keywords") ]
    colnames(tab) <- c("Name (hover for description)",  "5 stars",  "Scope", "Access", "Identifier", "Structure", "Publication date", "Last update date",  "Licence",  "material.keywords", "measurement.keywords")
    
    DT::datatable(tab, rownames = FALSE,  escape = FALSE, selection = 'single',
                  filter = "top",
                  options = list(lengthMenu = c(15, 30, 50, 100), pageLength = 15,
                                 orderClasses = TRUE,
                                 pageLength = nrow(tab),
                                 columnDefs = list(list(visible = FALSE,
                                                        targets = c("material.keywords", "measurement.keywords") ))))
  })
  
  # Table download   ----
  output$download.table <- downloadHandler(
    filename = "open-archeocsean-data.csv",
    content = function(file){
      write.csv(data, file, row.names = F)
    }
  )

  # Base map -----
    map.base <-
      leaflet::leaflet() %>%  
      leaflet::setView(lng = 180, lat = 0, zoom = 2)  %>%
      leaflet::addWMSTiles(baseUrl = 'https://ows.terrestris.de/osm/service?',
                  layers = "TOPO-WMS",
                  attribution = '&copy; <a href=https://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors')  %>%
      # addProviderTiles(providers$Esri.WorldPhysical) %>%
      # addProviderTiles(providers$OpenTopoMap) %>%   #Esri.WorldTerrain
      #  
      # addTiles("https://tiles.stadiamaps.com/tiles/stamen_terrain_background/{z}/{x}/{y}{r}.png",
      #          attribution = '&copy; <a href=https://www.stadiamaps.com/ target=_blank>Stadia Maps</a> &copy; <a href=https://www.stamen.com/ target=_blank>Stamen Design</a> &copy; <a href=https://openmaptiles.org/ target=_blank>OpenMapTiles</a> &copy; <a href=https://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors'
      #          ) %>%
      leaflet::addLegend("bottomright",    ## legend ----
                title = "Access",
                colors = access.color,
                labels = access.lvl,
                opacity = 0.8)
  
  surfaces <- sites[ ! is.na(sites$bbox.lon1), ]
  surfaces <- surfaces[order(abs(surfaces$area), decreasing = TRUE), ]
  surfaces$fillOpacity <- 0.1
  
  output$map <- renderLeaflet({ ## render map ----
      map <- map.base %>%  ## add surfaces ####
      leaflet::addRectangles(data = surfaces,
                    lng1 = ~bbox.lon1,
                    lat1 = ~bbox.lat1,
                    lng2 = ~bbox.lon2,
                    lat2 = ~bbox.lat2,
                    popup = ~popup,
                    color = "black",
                    opacity = 1,
                    fillColor = ~fillcolor,
                    fillOpacity = ~fillOpacity,
                    weight = .5, 
                    label = ~name,
                    options = pathOptions(clickable = TRUE, interactive = TRUE),
                    popupOptions = popupOptions(closeOnClick = TRUE)
      )
    # }
    
      ## add points ####
    map %>% leaflet::addCircleMarkers(data = sites[ ! is.na(sites$lat), ],
                             ~lon, ~lat,
                             popup = ~popup, layerId = ~id,
                             label = ~name,
                             color = ~color,
                             radius = 6,
                             fillOpacity = ~fillOpacity,
                             opacity = 0.99,
                             options = pathOptions(clickable = TRUE, interactive = TRUE),
                             popupOptions = popupOptions(closeOnClick = TRUE),
                             clusterOptions = markerClusterOptions(
                               spiderfyDistanceMultiplier = 1.5
                                                                   )) 
  })
  
  
  ## map update  ----
  observeEvent(input$table_rows_selected, {
    
    row <- input$table_rows_selected
    
    # reset values:
    sites$fillOpacity <- .1 # selected point is plain filled
    surfaces$fillOpacity <- .1
    surfaces$fillcolor <- "white"
    
    if(is.na(sites[row, ]$bbox.lon1)){
      sites[row, ]$fillOpacity <- 1 # selected point is plain filled
      target.lon <- sites[row, ]$lon
      target.lat <- sites[row, ]$lat
      zoom.lvl <- 5
    } else{
      target.lon <- median(c(sites[row, ]$bbox.lon2, sites[row, ]$bbox.lon1))
      target.lat <- median(c(sites[row, ]$bbox.lat2, sites[row, ]$bbox.lat1))
      zoom.lvl <- 3
      # put the selected surface on top and increase its opacity:
      surfaces <- surfaces[order(abs(surfaces$area), decreasing = TRUE), ]
      idx <- which(surfaces$id == sites[row, ]$id)
      
      surfaces[idx, ]$fillOpacity <- .8
      surfaces[idx, ]$fillcolor <- surfaces[idx, ]$color 
      surfaces <- rbind(surfaces[-idx, ], surfaces[idx, ]) 
      surfaces$id <- seq_len(nrow(surfaces))
    }
    
    leafletProxy("map")  %>% 
      clearMarkers()    %>%
      clearMarkerClusters()   %>%
      clearShapes() %>%
      setView(lng = target.lon, lat = target.lat, zoom = zoom.lvl)  %>%
      addRectangles(data = surfaces,
                    lng1 = ~bbox.lon1,
                    lat1 = ~bbox.lat1,
                    lng2 = ~bbox.lon2,
                    lat2 = ~bbox.lat2,
                    popup = ~popup,
                    color = "black",
                    opacity = 1,
                    fillColor = ~fillcolor,
                    fillOpacity = ~fillOpacity,
                    weight = .5,
                    label = ~name,
                    options = pathOptions(clickable = TRUE, interactive = TRUE),
                    popupOptions = popupOptions(closeOnClick = TRUE)) %>%
      addCircleMarkers(data = sites, lng= ~lon, lat = ~lat,
                       popup = ~popup,
                       layerId = ~id,
                       label = ~name,
                       color = ~color, radius = 6,
                       fillOpacity = ~fillOpacity,
                       clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier=1.5),
                       opacity = 0.99
                       )
  })
  
 
  
  
} # end of server.R

shinyApp(ui = ui, server = server)



