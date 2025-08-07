library(shinythemes)
library(leaflet)
library(DT)
library(leaflet.extras)
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
      <i>Open-archeOcsean</i> is a curated catalogue of open-source data sets regarding the archaeology of the Pacific and Southeast Asia region, developped in the context of the  <a href=https://www.ocsean.eu  target=_blank><i>Ocsean. Oceanic and Southeast Asian Navigators</i></a> project. 
    The data and app code source are available on <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a>.
    </p>
    <h3>Map exploration</h3>
      <p>
        Draw a rectangle to retrieve the resources corresponding to the selected area.  
      </p>
      <p>
        Note: <i>Open-archeOcsean</i>'s area of interest is defined between lon = [91.1426, 257.6953], and lat = [45.9511, -52.3756]. The coverage of data sets exceeding this surface could have been reduced to the part fitting within this area of interest.
      </p>

    <h3>Table exploration</h3>
      <p>
      Use the <b>Search field</b>  to retrieve resources by:
                   <ul>",
                                               span(
                                                 `data-toggle` = "tooltip", `data-placement` = "bottom",
                                                 title = "bone, botanical, burial, eggshell, ethnography, glass, lithic, organic tools, physical space, pottery, sediments, shell
",
                                                 HTML("<li><b>Material</b>:  <a href=>keywords</a>.</li>")),
                                               span(
                                                 `data-toggle` = "tooltip", `data-placement` = "bottom",
                                                 title = "granulometry, ICP-AES, isotopic, LA-ICP-MS, morphometrics, pXRF, radiocarbon, TL/OSL, TOC/TN, U/Th, XRD
",
                                                 HTML("<li><b>Measurement and description method</b>:  <a href=>keywords</a>.</li>")),
                                               "
                     </ul>
      Use <b>column filters</b> to retrieve resources by:
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
        <li> <b>File format</b>: available to retrieve the data.</li>
        </ul>
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
                                         "Click on a line to zoom the map on the corresponding resource.",
                                         br(),
                                         HTML("Click on the <img height=12px src=icon-doc.jpg> symbol to access the related documentation."),
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
                              <li> The <i>Open-archeOcsean</i> dataset and application are developed and maintained by <b>Sébastien Plutniak</b> (CNRS).</li>
                              <li> It benefited from the help of: Ethan Cochrane, Kristine Hardy, Mathieu Leclerc, Anna Pineda, Tim Thomas, Monika Karmin, Ruly Fauzi. </li>
                </ul>
                 <h2>Support</h2>
                 <div style='text-align:left'>
                    <b> <i>Open-archeOcsean</i></b>
                    <br><br>
                    <table> 
                      <tr>
                        <td> is supported by: &nbsp;  &nbsp; &nbsp; <br> <br> <a href=https://www.ocsean.eu/  target=_blank><img height='60px' src=logo-ocsean.jpg></a></td>
                        <td>is developped at: &nbsp; &nbsp; &nbsp;  <br> <br> <a href=https://www.cnrs.fr target=_blank><img height='60px' src=logo-cnrs.png></a></td>
                        <td>  is hosted by:  <br> <br> <a href=https://www.huma-num.fr/ target=_blank><img height='60px' src=logo-humanum.jpg></a></td>
                      </tr>
                    </table> 
                    <br>
                <p>    
                   This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No <a href=https://cordis.europa.eu/project/id/873207 target_blank>873207</a>.
                </p>
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
  
  ## convert longitudes in positive values for mapping purpose ----
  idx <- which(sites$bbox.lon1 < 0 & sites$bbox.lon2 < 0)
  sites[idx, ]$bbox.lon1 <- 180 + (180 + sites[idx, ]$bbox.lon1)
  idx <- which(sites$bbox.lon2 < 0)
  sites[idx, ]$bbox.lon2 <- 180 + (180 + sites[idx, ]$bbox.lon2)
  sites[which(sites$lon < 0), ]$lon <- 180 + (180 + sites[which(sites$lon < 0), ]$lon)
  
  ## area ----
  # compute.area <- function(lon1, lon2, lat1, lat2){
  #   lon1 <- as.numeric(lon1)
  #   lon2 <- as.numeric(lon2)
  #   lat1 <- as.numeric(lat1)
  #   lat2 <- as.numeric(lat2)
  #   lon.max <- sort(c(lon1, lon2))[1]
  #   lon.min <- sort(c(lon1, lon2))[2]
  #   lat.max <- sort(c(lat1, lat2))[1]
  #   lat.min <- sort(c(lat1, lat2))[2]
  #   
  #   (lon.max - lon.min) * (lat.max - lat.min)
  # }
  # sites$area <- apply(sites, 1, function(x) compute.area(
  #                                          lon1 = x[which(names(sites) == "bbox.lon1")],
  #                                          lon2 = x[which(names(sites) == "bbox.lon2")], 
  #                                          lat1 = x[which(names(sites) == "bbox.lat1")],
  #                                          lat2 = x[which(names(sites) == "bbox.lat2")])
        # )
  
  # areaPolygon
  
  area.km2 <- function(lon1, lat1, lon2, lat2){
    coords <- as.numeric(c(lon1, lon2, lat1, lat2)) * pi / 180 # convert to radian
    res <- 6378 ^ 2 * (sin(coords[3]) - sin(coords[4])) * (coords[1] - coords[2]) # earth radius: 6378137 m
    abs(res) # / 1000000
  }
  
  sites$area <- apply(sites, 1, function(x) 
    area.km2(
      lon1 = x[which(names(sites) == "bbox.lon1")],
      lat1 = x[which(names(sites) == "bbox.lat1")],
      lon2 = x[which(names(sites) == "bbox.lon2")],
      lat2 = x[which(names(sites) == "bbox.lat2")]
    )
  )
  
  # sites$area3 <- apply(sites, 1, function(x) {
  #     pp <- rbind(c(x[which(names(sites) == "bbox.lon1")],  x[which(names(sites) == "bbox.lat1")]),
  #                 c(x[which(names(sites) == "bbox.lon2")],  x[which(names(sites) == "bbox.lat1")]),
  #                 c(x[which(names(sites) == "bbox.lon2")],  x[which(names(sites) == "bbox.lat2")]),
  #                 c(x[which(names(sites) == "bbox.lon1")],  x[which(names(sites) == "bbox.lat2")]))
  #     geosphere::areaPolygon(pp) / 1000000
  #     }
  #   )
  
  
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
  sites$file.format <- factor(sites$file.format)
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
  tab <- eventReactive(input$map_draw_new_feature,{
    
    if(! is.null(input$map_draw_new_feature)){  ## rectangle selection----
      
      lon <- c(input$map_draw_new_feature$geometry$coordinates[[1]][[1]][[1]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[2]][[1]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[3]][[1]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[4]][[1]])
      
      lat <- c(input$map_draw_new_feature$geometry$coordinates[[1]][[1]][[2]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[2]][[2]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[3]][[2]],
               input$map_draw_new_feature$geometry$coordinates[[1]][[4]][[2]])
      
      min.lon <- min(lon)
      max.lon <- max(lon)
      min.lat <- min(lat) + 90 # convert to positive values only
      max.lat <- max(lat) + 90
      
      # selected points:
      idx.points <- (sites$lon >= min.lon &  sites$lon <=  max.lon)    &    (sites$lat >= min.lat &  sites$lat <=  max.lat)
      idx.points <- which(idx.points)
      
      # select surfaces:
      ## area with no horizontal overlap with the selected area: 
      horiz.overlap <- (sites$bbox.lon1 < min.lon & sites$bbox.lon2 < min.lon) | 
        (sites$bbox.lon1 > max.lon & sites$bbox.lon2 > max.lon)
      ## area with no vertical overlap with the selected area: 
      vert.overlap  <- (sites$bbox.lat1 + 90 > max.lat & sites$bbox.lat2 + 90 > max.lat) | 
        (sites$bbox.lat1 + 90 < min.lat & sites$bbox.lat2 + 90 < min.lat)
      
      idx.surf <- which( ! horiz.overlap & !vert.overlap)
      
      # subset
      sites <- sites[c(idx.surf, idx.points), ]
    }
      
      tab <- sites[ , c("resource.name",   "five.stars.score.label",  "scope", "access", "pid", "file.format", "date_publication", "date_last.update", "licence", "material.keywords", "measurement.keywords") ]
      colnames(tab) <- c("Name (hover for description)",  "5 stars",  "Scope", "Access", "Identifier", "Format", "Publication date", "Last update date",  "Licence",  "material.keywords", "measurement.keywords")
      tab
  }, ignoreInit = F, ignoreNULL = FALSE)
  
 output$table <- DT::renderDataTable({
    tab <- tab()
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
      leaflet::addWMSTiles(baseUrl = 'https://ows.terrestris.de/osm/service?',   ## WMS ----
                  layers = "TOPO-WMS",
                  options =  WMSTileOptions(minZoom = 2),
                  attribution = '&copy; <a href=https://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors')  %>%
      # leaflet::addProviderTiles("Esri.OceanBasemap", group = "Ocean Basemap",
      #                           providerTileOptions(minZoom=2) )   %>%
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
  
  
  output$map <- renderLeaflet({ # Render map ----
    map.base %>% 
      leaflet::addRectangles(data = surfaces,                   ## add surfaces----
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
        leaflet::addCircleMarkers(data = sites[ ! is.na(sites$lat), ],  ## add points ----
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
                               )
                             ) %>% 
        leaflet.extras::addDrawToolbar(targetGroup = 'draw',             ## add draw tool ----
                                       polylineOptions= FALSE, polygonOptions=FALSE, circleOptions = FALSE,
                                       markerOptions = FALSE, circleMarkerOptions=FALSE, singleFeature = TRUE)
  })
  
  
  # Map update  ----
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
                       ) %>% 
      leaflet.extras::addDrawToolbar(targetGroup = 'draw', 
                     polylineOptions= FALSE, polygonOptions=FALSE, circleOptions = FALSE,
                     markerOptions = FALSE, circleMarkerOptions=FALSE, 
                     singleFeature = TRUE)      
  })
  
 
  
  
} # end of server.R

shinyApp(ui = ui, server = server)



