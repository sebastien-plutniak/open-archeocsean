remotes::install_github("sebastien-plutniak/spatialCatalogueViewer")

# data preparation  ----
data <- read.csv("data/open-archeocsean-data.csv")

data$resource.name <- data$name

## resource name and link ----
data$resource.name.html <- paste0("<a href=", data$download_url, " title='", data$description, "' target=_blank>", data$name, "</a> ",
                              "<a href=", data$info_url, " title='Click to access related documentation.' target=_blank><img height=12px src=icon-doc.jpg></a>")

## PID ----
data$pid <- "url"
data[grep("doi", data$download_url), ]$pid <- "doi"
data[grep("hdl", data$download_url), ]$pid <- "hdl"
data$pid <- factor(data$pid )

## popup ----
data$tab.link <- paste0("<a href=", data$download_url, " title='Click to access this resource' target=_blank>", data$name, "</a>")
data$popup <- paste0("<b>", data$tab.link, "</b><br>", 
                      data$description, ".<br>",
                      "<b>Licence:</b> ", data$licence, "<br>",
                      "<b>Access:</b> ", data$access)

legend.labels <- c("open", "embargoed", "failing", "restricted")
legend.colors <- c("darkgreen", "purple", "yellow", "red") 


## periods -----
# data$period <-  data$period1
# idx <- data$period2 != ""
# data[idx, ]$period <- paste0(data[idx, ]$period1,
#                               " → ", data[idx, ]$period2)

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

data$five.stars.score.label <- apply(data, 1, function(x) 
  five.stars.score(item = x, score = x[which(colnames(data) == "five.stars.score")] ))


data$access <- factor(data$access)
data$scope <- factor(data$scope)
data$licence <- factor(data$licence)
data$file.format <- factor(data$file.format)
data$storage <- factor(data$storage)

## material & measurements ---- 
idx <- grep("material", names(data))
data$material.keywords <- apply(data[, idx], 1, paste0, collapse = " ")

idx <- grep("measurement_type", names(data))
data$measurement.keywords <- apply(data[, idx], 1, paste0, collapse = " ")


data <- data[ , c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name", "popup",  "resource.name.html", "five.stars.score.label",  "scope", "access", "pid", "file.format", "date_publication", "date_last.update", "licence", "material.keywords", "measurement.keywords") ]
colnames(data) <- c("lon", "lat", "bbox.lon1", "bbox.lat1", "bbox.lon2", "bbox.lat2", "resource.name","popup",  "Name (hover for description)",  "5 stars",  "Scope", "Access", "Identifier", "Format", "Publication date", "Last update date",  "Licence",  "material.keywords", "measurement.keywords")



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

text.left <- "<div style=width:90%;, align=left>
             <h2>Presentation</h2>
    <p>
      <i>Open-archeOcsean</i> is a curated catalogue of open-source data sets regarding the archaeology of the Pacific and Southeast Asia region, developped in the context of the  <a href=https://www.ocsean.eu  target=_blank><i>Ocsean. Oceanic and Southeast Asian Navigators</i></a> project. 
    The data and app code source are available on <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a>.
    </p>
    <h3>Map exploration</h3>
      <p>
        Draw a rectangle to retrieve the datasets related to the selected area.  
      </p>
      <p>
        Note: <i>Open-archeOcsean</i>'s area of interest is defined between lon = [91.1426, 257.6953], and lat = [45.9511, -52.3756]. The coverage of data sets exceeding this surface could have been reduced to the part fitting within this area of interest.
      </p>

    <h3>Table exploration</h3>
      <p>
      Use the <b>Search field</b>  to retrieve resources by:
                   <ul>
                      <li><b>Material</b>: 
                        <span data-toggle='tooltip' data-placement='bottom' title='bone, botanical, burial, eggshell, ethnography, glass, lithic, organic tools, physical space, pottery, sediments, shell'>
                      <a href=>keywords</a></span>.</li>
                      <li><b>Measurement and description method</b>:  
                      <span data-toggle='tooltip' data-placement='bottom' title='granulometry, ICP-AES, isotopic, LA-ICP-MS, morphometrics, pXRF, radiocarbon, TL/OSL, TOC/TN, U/Th, XRD'>
                      <a href=>keywords</a></span>.</li>
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
      </div>"

text.bottom <- "Click on the <img height=12px src=icon-doc.jpg> symbol to access the related documentation."

contribute.tab <- "<h2>Contact</h2>
                    Contributions are welcome and can be done:
                    <ul>
                     <li>either by email: sebastien.plutniak_at_cnrs.fr</li>
                     <li>or by creating an 'issue' or a 'pull request' on the <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a> repository. </li>
                    </ul>"

credits.tab <-  "<h2>Credits</h2>
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
                  </div>"


# exec spatialCatalogueViewer----
spatialCatalogueViewer::spatialCatalogueViewer(data = data,   
                                               text.title = text.title,
                                               text.left = text.left, 
                                               text.bottom = text.bottom,
                                               map.provider = "Esri.WorldPhysical",
                                               map.set.lon = 180, map.set.lat = 0,
                                               map.legend.variable = "Access", 
                                               map.legend.labels = legend.labels, 
                                               map.legend.colors = legend.colors,
                                               map.height = 600,
                                               map.area.fill.color = "white",
                                               map.area.fill.opacity = .1,
                                               map.show.areas = "always",
                                               map.min.zoom = 2,
                                               table.hide.columns = c("resource.name", "material.keywords", "measurement.keywords"), 
                                               table.filter = "top", 
                                               table.pageLength = 15,
                                               data.download.button = TRUE,
                                               tabs.contents = list("Contribute" = contribute.tab, "Contributors & Credits" = credits.tab),
                                               css = css, js = js,
                                               theme = "cerulean") 


