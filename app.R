remotes::install_github("sebastien-plutniak/spatialCatalogueViewer", upgrade = "never")



try(archeocsean.df <- read.csv("data/open-archeocsean-data_formated.csv", check.names=FALSE), silent=TRUE)

if( ! exists("archeocsean.df")){
  # data preparation  ----
  archeocsean.df <- read.csv("data/open-archeocsean-data.csv")
  archeocsean.df$resource.name <- archeocsean.df$name
  
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
      res <- paste0(c(
        "<div title='Score: ", score, "'>",
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
text.left <- "<div style=width:90%;, align=left>
             <h2>Presentation</h2>
    <p>
      <i>Open-archeOcsean</i> is a curated catalogue of open-source data sets regarding the archaeology of the Pacific and Southeast Asia regions.
      This initiative started in the context of the <a href=https://www.ocsean.eu  target=_blank><i>Ocsean. Oceanic and Southeast Asian Navigators</i></a> project. 
    The data and app code source are available on <a href=https://github.com/sebastien-plutniak/open-archeocsean target=_blank><i>github</i></a> and archived on <a href=https://doi.org/10.5281/zenodo.16812839 target=_blank><i>Zenodo</i></a>.
    </p>
    <h3>Table Exploration</h3>
      <p>
      Use the <b>Search field</b>  to retrieve resources by:
                   <ul>
                      <li><b>Material</b>: 
                        <span data-toggle='tooltip' data-placement='bottom' title='bone, botanical, burial, eggshell, ethnography, excavation documents, glass, lithic, organic tools, paleoclimate, physical space, pottery, rice, sea level, sediments, shell'>
                      <a href=>keywords</a></span>.</li>
                      <li><b>Measurement and description method</b>:  
                      <span data-toggle='tooltip' data-placement='bottom' title='granulometry, ICP-AES, isotopic, LA-ICP-MS, morphometrics, pXRF, radiocarbon, TL/OSL, TOC/TN, U/Th, XRD'>
                      <a href=>keywords</a></span>.</li>
                    </ul>
      Use <b>column filters</b> to retrieve resources by:
     <ul>
     
        <li> <b>5-stars</b> score: the <a href=https://5stardata.info/ target=_blank>5-stars</a> linked open data score reflects how well data is integrated into the Web.</li>
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
            <li><i>Embargoed</i>: access to the resource will be possible at a stated date in the future.</li>
          </ul>
        </li>
        <li> <b>File format</b>: publication format of the dataset.</li>
        </ul>
      </p>
      </div>"

text.bottom <- "Click on the <img height=12px src=icon-doc.jpg> symbol to access the related documentation."

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
                      <i>Open-archeOcsean</i>'s area of interest spans between longitude = [91.1426, 257.6953] and latitude = [45.9511, -52.3756]. Note that the represented coverage of data sets exceeding this surface could have been reduced to their part fitting within this area of interest.
                    </p>
                  <h3>Time Period</h3>
                    <p>
                       From the earliest traces of human presence to today. However, note that datasets about recent period (e.g., colonial period) are referenced only if they present an interest for the study of long-term human presence in the region. 
                    </p>
                  <h3>Public Availability</h3>
                    <p>
                      To be listed in <i>Open-archeOcsean</i>, a resource must at least meet the following requirements:
                      <ul>
                        <li>be accessible online (possibly: at a determined date in the future for embargoed resources,  or under the condition of a free registration open to everyone), </li>
                        <li>be downloadable by users.</li>
                      </ul>
                       Resources which tend to comply with the <a href=https://www.go-fair.org/fair-principles/ target=_blank>FAIR</a> principles are favored. 
                    </p>
                  </div>
"

## credits ----
credits.tab <-  "<div  style=width:50%;, align=left> 
                <h2>Credits </h2>
                  <ul>
                     <li> The <i>Open-archeOcsean</i> dataset and application are developed and maintained by <b>Sébastien Plutniak</b> (CNRS).</li>
                     <li> It benefited from suggestions by: Ethan Cochrane, Kristine Hardy, Mathieu Leclerc, Anna Pineda, Tim Thomas, Monika Karmin, Ruly Fauzi. </li>
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
                      <b> <i>Open-archeOcsean</i></b>
                      <br><br>
                      <table> 
                        <tr>
                          <td> is supported by: &nbsp;  &nbsp; &nbsp; <br> <br> <a href=https://www.ocsean.eu/  target=_blank><img height='60px' src=logo-ocsean.jpg></a></td>
                          <td>is developped at: &nbsp; &nbsp; &nbsp;  <br> <br> <a href=https://www.cnrs.fr target=_blank><img height='60px' src=logo-cnrs.png></a></td>
                          <td>  is hosted by:  <br> <br> <a href=https://www.huma-num.fr/ target=_blank><img height='60px' src=logo-humanum.jpg></a></td>
                           <td> is listed as: &nbsp; <br>  <br><a href=https://www.re3data.org/repository/r3d100014682  target=_blank><img height='60px' src=logo-re3data.png></a></td>
                        </tr>
                      </table> 
                      <br>
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
                                               map.legend.labels = c("open",  "embargoed", "failing",  "restricted"), 
                                               map.legend.colors = c("darkgreen", "purple", "yellow", "red"),
                                               map.height = 600,
                                               map.area.fill.color = "white",
                                               map.area.fill.opacity = .1,
                                               map.show.areas = "always",
                                               map.min.zoom = 2,
                                               table.hide.columns = c("resource.name", "material.keywords", "measurement.keywords"), 
                                               table.filter = "top", 
                                               table.pageLength = 15,
                                               data.download.button = TRUE,
                                               tabs.contents = list("Contribute" = contribute.tab, "Credits" = credits.tab),
                                               css = css, js = js,
                                               theme = "cerulean") 


