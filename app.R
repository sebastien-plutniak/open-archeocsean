remotes::install_github("sebastien-plutniak/spatialCatalogueViewer", upgrade = "never")

log.df <- read.csv( "../openarcheocsean-log.csv")
write.csv(rbind(log.df, "date" = format(Sys.Date())), "../openarcheocsean-log.csv", row.names = F)

try(archeocsean.df <- read.csv("data/open-archeocsean-data_formated.csv", check.names=FALSE), silent=TRUE)

if( ! exists("archeocsean.df")){
  # data preparation (1)  ----
  archeocsean.df <- read.csv("data/open-archeocsean-data.csv")
  archeocsean.df$resource.name <- archeocsean.df$name
  
  # ## remove lines with no coordinates: ----
  # idx <- apply(archeocsean.df[, c("lon", "lat",	"bbox.lon1",	"bbox.lat1", "bbox.lon2",	"bbox.lat2")], 1, 
  #              function(x) sum(is.na(x)))
  # archeocsean.df <- archeocsean.df[idx < 6, ]
  
  
  # generate stats ----
  library(ggplot2)
  
  ## methods ----
  measurements.values <- unlist(archeocsean.df[, grep("measurement", names(archeocsean.df))])
  measurements.values <- data.frame(sort(table(measurements.values)))
  measurements.values <- measurements.values[measurements.values$measurements.values != "", ]
  
  measurements.values$domain <- "archaeology"
  # unique(measurements.values$measurements.values)
  
  measurements.values[measurements.values$measurements.values %in% c("granulometry", "petrography", "thin section"),]$domain <- "geology"
  measurements.values[measurements.values$measurements.values %in% c("radiocarbon", "U/Th", "TL/OSL"),]$domain <- "datation"
  measurements.values[measurements.values$measurements.values %in% c("photography", "3d modelling", "LIDAR"),]$domain <- "visualisation"
  measurements.values[measurements.values$measurements.values %in% c("AMS", "pXRF", "XRD", "LA-ICP-MS", "ICP-AES", "isotopic", "TOC/TN"),]$domain <- "chemical composition"
  
  
  ggplot(measurements.values, aes(y = measurements.values, x = Freq, fill = domain)) +
    theme_light() +
    scale_fill_viridis_d("Domain") +
    geom_bar(stat = "identity",  color= "black", linewidth = .3) +
    ylab("Methods") + xlab("Nr of resources") 
  ggsave("www/archeocsean-measurement.png", width = 8, height = 5)
  
  
  ## materials ----
  material.values <- unlist(archeocsean.df[, grep("material", names(archeocsean.df))])
  material.values <- data.frame(sort(table(material.values)))
  material.values <- material.values[material.values$material.values != "", ]
  
  material.values$category <- "Archaeological remains"
  # unique(material.values$material.values)
  
  material.values[material.values$material.values %in% c("sites", "burial"), ]$category <- "Archaeological features"
  material.values[material.values$material.values %in% c("paleoclimate", "islands", "sea level"), ]$category <- "Environment"
  material.values[material.values$material.values %in% c("ethnography"), ]$category <- "Ethnography"
  material.values[material.values$material.values %in% c("sediments"), ]$category <- "Sediments"
  material.values[material.values$material.values %in% c("charcoal", "rice", "botanical"), ]$category <- "Vegetal remains"
  material.values[material.values$material.values %in% c("excavation documents"), ]$category <- "Excavation documents"
  
  ggplot(material.values, aes(y = material.values, x = Freq, fill= category)) +
    theme_light() +
    scale_fill_viridis_d("Category") +
    geom_bar(stat = "identity", color= "black", linewidth = .3) + 
    ylab("Material category") + xlab("Nr of resources")
  ggsave("www/archeocsean-material.png", width = 8, height = 5)
  
  
  ## licences ----
  licences.values <- data.frame(sort(table(archeocsean.df$licence)))
  
  licences.values$fill <- "gray"
  licences.values[licences.values$Var1 == "?",]$fill <- "white"
  
  ggplot(licences.values, aes(y = Var1, x = Freq, fill = fill)) +
    theme_light() +
    geom_bar(stat = "identity", show.legend = F, color= "black", linewidth = .3) + 
    scale_fill_grey(start = 0.4,
                    end = 1) +
    ylab("Licence") + xlab("Nr of resources")
  ggsave("www/archeocsean-licences.png", width = 6, height = 5)
  
  
  ## file formats ----
  formats.values <- data.frame(sort(table(archeocsean.df$file.format)))
  
  # unique(formats.values$Var1)
  formats.values$type <- ""
  
  formats.values[formats.values$Var1 %in% c("CSV", "TXT", "XLSX", "XLS"), ]$type <- "tabular"
  formats.values[formats.values$Var1 %in% c("ACCDB"), ]$type <- "database"
  formats.values[formats.values$Var1 %in% c("DOC", "HTML"), ]$type <- "text"
  formats.values[formats.values$Var1 %in% c("TIFF, SHP", "JPG", "OBJ"), ]$type <- "graphical"
  formats.values[formats.values$Var1 %in% c("GeoTIFF", "SHP", "MPK"), ]$type <- "spatial"
  formats.values[formats.values$Var1 %in% c("PDF"), ]$type <- "other"
  
  ggplot(formats.values, aes(y = Var1, x = Freq, fill = type)) +
    theme_light() +
    geom_bar(stat = "identity", show.legend = T, color= "black", linewidth = .3) + 
    scale_fill_viridis_d() +
    ylab("File format") + xlab("Nr of resources")
  ggsave("www/archeocsean-file-format.png", width = 8, height = 5)
  
  
  ## 5-stars score ----
  five.stars.score <- data.frame(table(archeocsean.df$five.stars.score))
  
  five.stars.score$Var1 <- as.character(five.stars.score$Var1)
  five.stars.score <- rbind(five.stars.score, c(5,0))
  five.stars.score$Freq <- as.numeric(five.stars.score$Freq)
  
  ggplot(five.stars.score, aes(x = Var1, y = Freq)) +
    theme_light() +
    geom_bar(stat = "identity", show.legend = T, color= "black", linewidth = 0) + 
    scale_x_discrete("5-stars score") +
    ylab("Nr of resources") 
  ggsave("www/archeocsean-five-stars.png", width = 8, height = 5)
  
  
  # data preparation (2) ----
  
  ## resource name and link ----
  archeocsean.df$resource.name.html <- paste0("<a href=", archeocsean.df$download_url, " title='", archeocsean.df$description, "' target=_blank>", archeocsean.df$name, "</a> ",
                                              "<a href=", archeocsean.df$info_url, " title='Click to access related documentation.' target=_blank><img height=12px src=icon-doc.jpg></a>")
  
  ## PID ----
  archeocsean.df$pid <- "url"
  archeocsean.df[grep("doi", archeocsean.df$download_url), ]$pid <- "doi"
  archeocsean.df[grep("hdl", archeocsean.df$download_url), ]$pid <- "hdl"
  archeocsean.df$pid <- factor(archeocsean.df$pid)
  
  ## popup ----
  archeocsean.df$tab.link <- paste0("<a href=", archeocsean.df$download_url, " title='Click to access this resource' target=_blank>", archeocsean.df$name, "</a>")
  archeocsean.df$popup <- paste0("<b>", archeocsean.df$tab.link, "</b><br>", 
                                 archeocsean.df$description, ".<br>",
                                 "<b>Licence:</b> ", archeocsean.df$licence, "<br>",
                                 "<b>Access:</b> ", archeocsean.df$access)
  
  ## periods -----
  # archeocsean.df$period <-  archeocsean.df$period1
  # idx <- archeocsean.df$period2 != ""
  # archeocsean.df[idx, ]$period <- paste0(archeocsean.df[idx, ]$period1,
  #                               " → ", archeocsean.df[idx, ]$period2)
  
  ## color ----
  archeocsean.df$fillColor <- as.character(factor(archeocsean.df$access, c("open", "embargoed", "failing", "restricted"),
                                                  labels =  c("darkgreen", "purple", "yellow", "red")))
  
  ## 5 stars scale ----
  five.stars.score <- function(item, score){
    score <- as.numeric(score)
    res <- ""
    if(! is.na(score)){
      val <- c("", "open licence", "structured format", "non-proprietary format", "URI", "semantic web")
      idx <- 0:score + 1
      title.str <- paste0("Score: ", score, paste0(val[idx], collapse = ", "))
      
      res <- paste0(c(
        "<div title='", title.str, "'>",
        paste0(rep("<font  color='gold'>★</font>", score), collapse = ""),
        paste0(rep("<font color='LightGray'>★</font>", 5 - score), collapse = ""),
        "</div>"
      ),
      collapse = "")
    }
    res  
  }
  
  archeocsean.df$five.stars.score.label <- apply(archeocsean.df, 1, function(x) 
    five.stars.score(item = x, score = x[which(colnames(archeocsean.df) == "five.stars.score")] ))
  
  
  archeocsean.df$access <- factor(archeocsean.df$access)
  archeocsean.df$scope <- factor(archeocsean.df$scope)
  archeocsean.df$licence <- factor(archeocsean.df$licence)
  archeocsean.df$file.format <- factor(archeocsean.df$file.format)
  archeocsean.df$storage <- factor(archeocsean.df$storage)
  
  ## material & measurements ---- 
  idx <- grep("material", names(archeocsean.df))
  archeocsean.df$material.keywords <- apply(archeocsean.df[, idx], 1, paste0, collapse = " ")
  
  idx <- grep("measurement_type", names(archeocsean.df))
  archeocsean.df$measurement.keywords <- apply(archeocsean.df[, idx], 1, paste0, collapse = " ")
  
  
  archeocsean.df <- archeocsean.df[ , c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name", "popup", "fillColor", "resource.name.html", "five.stars.score.label",  "scope", "access", "pid", "file.format", "date_publication", "date_last.update", "licence", "material.keywords", "measurement.keywords") ]
  colnames(archeocsean.df) <- c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name","popup", "fillColor", "Name (hover for description)",  "5 stars",  "Scope", "Access", "Identifier", "Format", "Publication date", "Last update date",  "Licence",  "material.keywords", "measurement.keywords")
  
  write.csv(archeocsean.df, "data/open-archeocsean-data_formated.csv", row.names = FALSE)
}

archeocsean.df$Identifier <- factor(archeocsean.df$Identifier)
archeocsean.df$Access <- factor(archeocsean.df$Access)
archeocsean.df$Scope <- factor(archeocsean.df$Scope)
archeocsean.df$Licence <- factor(archeocsean.df$Licence)
archeocsean.df$Format <- factor(archeocsean.df$Format)


# css ----
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
  font-size: px;
  text-transform: none;
  font-weight: normal;
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

# texts ----

text.title <- "<h1>
             <a href=https://www.ocsean.eu/  target=_blank><img height='40px' src=logo-ocsean.jpg></a> 
             <i><a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank>Open-archeOcsean</a></i>
              </h1>"

## left----

## data categories ----
# objects.categories <- sort(unique(c(archeocsean.df$material1, archeocsean.df$material2, archeocsean.df$material3,
#                                     archeocsean.df$material4,archeocsean.df$material5)))
# paste0(objects.categories[objects.categories != ""], collapse = ", ")


text.left <- "<div style=width:90%;, align=left>
             <h2>Presentation</h2>
    <p>
      <i>Open-archeOcsean</i> is a curated catalogue of open resources useful to the archaeology of the Pacific and Southeast Asia regions.
      This initiative started in the context of the <a href=https://www.ocsean.eu  target=_blank><i>Ocsean. Oceanic and Southeast Asian Navigators</i></a> project. 
    The data and application code source are available on <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a>. Versions of the app are archived on <a href=https://doi.org/10.5281/zenodo.16812839 target=_blank><i>Zenodo</i></a>.
    </p>
    <h3>Table Exploration</h3>
      <p>
      Use the <b>'search' field</b>  to retrieve resources by:
                   <ul>
                      <li><b>Object</b>: 
                        <span data-toggle='tooltip' data-placement='bottom' title='bones, botanical, burial, charcoal, eggshell, ethnography, excavation documents, glass, islands, lithic, organic tools, paleoclimate, pottery, rice, sea level, sediments, shell, sites'>
                      <a href=>keywords</a></span>.</li>
                      <li><b>Measurement and description method</b>:  
                      <span data-toggle='tooltip' data-placement='bottom' title='3d modelling, granulometry, ICP-AES, isotopic, LA-ICP-MS, mapping, morphometrics, petrography, photography, pXRF, radiocarbon, technology, thin section, TL/OSL, TOC/TN, U/Th, XRD'>
                      <a href=>keywords</a></span>.</li>
                    </ul>
      Use <b>column filters</b> to retrieve resources by:
     <ul>
     
        <li> <b>5-stars</b> score: the <a href=https://5stardata.info/ target=_blank>5-stars</a> linked open data score reflects how well data is integrated into the Web.</li>
        <li> <b>Scope</b>:
          <ul>
            <li><i>Single site</i>: the resource regards one archaeological site, represented as a point on the map.</li>
            <li><i>Multi sites</i>: the resource regards several archaeological sites, represented as a surface on the map.</li>
          </ul>
        </li>
        <li> <b>Access mode</b>:
          <ul>
            <li><i>Open</i>: the resource can be directly accessed using the provided link.</li>
            <li><i>Restricted</i>: access to the resource must be requested using the provided link.</li>
            <li><i>Embargoed</i>: access to the resource will be possible at a given future date.</li>
          </ul>
        </li>
        <li> <b>File format</b>: file format in which data are published in the resource.</li>
        </ul>
      </p>
      </div>"

text.bottom <- "Click on the <img height=12px src=icon-doc.jpg> symbol to access the related documentation."


## summary ----
summary.tab <-  "<div  style=width:50%;, align=left> 
      <h2>Categories of material</h2>
      <img width='100%' src=archeocsean-material.png>
      <h2>Measurement & description methods</h2>
      <img width='100%' src=archeocsean-measurement.png>
      <h2>Licence</h2>
      <img width='100%' src=archeocsean-licences.png>
      <h2>Five-stars score</h2>
      <img width='100%' src=archeocsean-five-stars.png>
      <h2>File formats</h2>
      <img width='100%' src=archeocsean-file-format.png>
   </div>"

## contribute ----
contribute.tab <- "<div  style=width:50%;, align=left> 
                    <h2>How to Contribute?</h2>
                    Contributions are welcome and can be done:
                    <ul>
                     <li> by email: sebastien.plutniak_at_cnrs.fr</li>
                     <li> by creating an 'issue' or a 'pull request' on the <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a> repository. </li>
                    </ul>
                  <h2>Catalogue Scope</h2>
                     <i>Open-archeOcsean</i> lists data resources relevant to the long-term study of human settlement in the Southeast Asia and Pacific regions. 
                    <h3>Domain</h3>
                    <p>
                     Archaeological data is  <i>Open-archeOcsean</i>'s main focus, however paleoenvironmental, geological, and bio-anthropology (excluding molecular studies) data is also considered as far as it contributes to the understanding of long-term human presence in the area of interest.
                    </p>
                  <h3>Spatial Coverage</h3>
                    <p>
                      <i>Open-archeOcsean</i>'s area of interest spans between longitude = [91, -109] and latitude = [46, -53]. Note that for data set with coverage larger than  <i>Open-archeOcsean</i>'s area of interest, the encoded coverage might have been reduced to the surface fitting within our area of interest.
                    </p>
                  <h3>Time Period</h3>
                    <p>
                       From the earliest traces of <i>homo</i> presence to the beginning of the 20th century. 
                    </p>
                  <h3>Public Availability</h3>
                    <p>
                      To be listed in <i>Open-archeOcsean</i>, a resource must be:
                      <ul>
                        <li> accessible online:
                          <ul>
                            <li> now / at a stated date in the future for embargoed resources</li>
                            <li> openly / under registration, if free and open to everyone</li>.
                          </ul>
                        </li>
                        <li>downloadable by users in a processable format.</li>
                      </ul>
                       Resources complying with the <a href=https://www.go-fair.org/fair-principles/ target=_blank>FAIR</a> principles are favored. <a href=https://www.gida-global.org/care target_blank>CARE</a> principles, if stated, are reflected by the 'Access' variable.
                    </p>
                  </div>
"

## credits ----
credits.tab <-  "<div  style=width:50%;, align=left> 
                <h2>Credits </h2>
                  <ul>
                     <li> The <i>Open-archeOcsean</i> dataset and application are developed and maintained by <b>Sébastien Plutniak</b> (CNRS).</li>
                     <li> It benefited from suggestions by: Ethan Cochrane, Kristine Hardy, Mathieu Leclerc, Anna Pineda, Tim Thomas, Monika Karmin, Ruly Fauzi, Eugénie Gauvrit-Roux. </li>
                  </ul>
                   <h2>Citation</h2>
                    <p>To cite <i>Open-archeOcsean</i>, use:
                      <ul><li>
                      <b>Plutniak S. 2025</b>. 'open-archeOcsean: an interactive catalogue of open source datasets for the archaeology of the Pacific and Southeast Asia regions (v1.0.0)'. <i>Zenodo</i>, doi: <a href=https://doi.org/10.5281/zenodo.16812839 target=_blank>10.5281/zenodo.16812839</a>.
                      </li></ul>
                    </p>
                  <h2>Terms of Use</h2>
                  <p>
                    The use of the  <i>Open-archeOcsean</i> catalogue denotes agreement with the following terms:
                    <ul>
                        <li> <i>Open-archeOcsean</i> is provided free of charge and is distributed under open licences:
                          <ul>
                            <li> All metadata and data are made available under the terms of the <a href=https://creativecommons.org/licenses/by/4.0/ target_blank>CC-BY-4.0</a> license.</li>
                            <li>The software code draws on the <a href=https://CRAN.R-project.org/package=spatialCatalogueViewer target=_blank><i>spatialCatalogueViewer</i></a> R package, which is distibuted under a <a href=https://www.r-project.org/Licenses/GPL-3 target_blank>GPL-3</a> license.</li>
                          </ul>
                        </li>
                        <li> All content is provided “as is” and the user shall hold the content providers free and harmless in connection with its use of such content.</li>
                        <li> These terms of use are subject to change at any time and without notice, other than through posting the updated Terms of Use on this page.</li>
                    </ul>
                    If you have any questions or comments with respect to <i>Open-archeOcsean</i>, or if you are unsure whether your intended use is in line with these Terms of Use, or if you seek permission for a use that does not fall within these Terms of Use, please contact us.
                  </p>
                   <h2>Support</h2>
                   <div style='text-align:left'>
                      <b> <i>Open-archeOcsean</i></b> is
                      <br><br>
                      <table> 
                        <tr>
                          <td> supported by: &nbsp;  &nbsp; &nbsp; <br> <br> <a href=https://www.ocsean.eu  target=_blank><img height='50px' src=logo-ocsean.jpg></a></td>
                          <td> developped at: &nbsp; &nbsp; &nbsp;  <br> <br> <a href=https://www.cnrs.fr target=_blank><img height='50px' src=logo-cnrs.png></a></td>
                          <td>   hosted by:  <br> <br> <a href=https://www.huma-num.fr target=_blank><img height='50px' src=logo-humanum.jpg></a></td>
                          </tr>
                      </table> 
                      <br><br>
                       listed in: 
                           <a href=https://www.re3data.org/repository/r3d100014682  target=_blank><img height='50px' src=logo-re3data.png></a>  &nbsp;  &nbsp;
                           <a href=https://fairsharing.org/6849  target=_blank><img height='50px' src=logo-fairsharing.jpg></a>  &nbsp;  &nbsp;
                           <a href=https://marketplace.sshopencloud.eu/tool-or-service/E8NWsR  target=_blank><img height='50px' src=logo-sshom.jpg></a>
                      <br><br><br>
                      <p>    
                         This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No <a href=https://cordis.europa.eu/project/id/873207 target_blank>873207</a>.
                      </p>
                  </div></div>"





# exec spatialCatalogueViewer----
spatialCatalogueViewer::spatialCatalogueViewer(data = archeocsean.df,   
                                               text.title = text.title,
                                               text.left = text.left, 
                                               text.bottom = text.bottom,
                                               map.provider = "Esri.WorldPhysical",
                                               map.set.lon = 180, map.set.lat = 0,
                                               map.legend.variable = "Access", 
                                               map.legend.labels = c("open",  "embargoed",  "restricted"), 
                                               map.legend.colors = c("darkgreen", "purple", "yellow"),
                                               map.height = 600,
                                               map.area.fill.color = "white",
                                               map.area.fill.opacity = .1,
                                               map.show.areas = "always",
                                               map.min.zoom = 2,
                                               table.hide.columns = c("resource.name", "material.keywords", "measurement.keywords"), 
                                               table.filter = "top", 
                                               table.pageLength = 15,
                                               data.download.button = TRUE,
                                               tabs.contents = list("Contribute" = contribute.tab, "Summary" = summary.tab, "Credits" = credits.tab),
                                               css = css, js = js,
                                               theme = "cerulean") 


