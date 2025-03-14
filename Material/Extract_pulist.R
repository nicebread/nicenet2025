# Load necessary libraries
library(stringr)

# Function to extract information from HTML
extract_info <- function(html_content) {
  # Split the HTML content into individual <li> elements
  li_elements <- str_extract_all(html_content, "<li>.*?</li>")[[1]]
  
  # Initialize data frame
  result_df <- data.frame(
    doi = character(),
    OpenAccess = character(),
    OpenData = character(),
    Preregistration = character(),
    OpenMaterial = character(),
    stringsAsFactors = FALSE
  )
  
  # Process each <li> element
  for (li in li_elements) {
    # Extract DOI
    # Look for patterns like "doi:10.1002/per.2227" or "DOI: http://doi.org/10.1525/collabra.278"
    doi_match <- str_extract(li, "(doi|DOI):?\\s*(?:http://doi\\.org/|https://doi\\.org/)?\\s*[0-9]+\\.[0-9]+/[^\\s<>\"']+")
    if (!is.na(doi_match)) {
      doi <- str_replace(doi_match, "(doi|DOI):?\\s*(?:http://doi\\.org/|https://doi\\.org/)?\\s*", "")
    } else {
      # Look for patterns like "https://doi.org/10.1002/per.2227"
      doi_url_match <- str_extract(li, "https?://(?:dx\\.)?doi\\.org/[0-9]+\\.[0-9]+/[^\\s\"'<>]+")
      if (!is.na(doi_url_match)) {
        doi <- str_replace(doi_url_match, "https?://(?:dx\\.)?doi\\.org/", "")
      } else {
        doi <- NA
      }
    }
    
    # Extract links
    # OpenAccess
    oa_match <- str_extract(li, '<a href="[^"]+">\\s*<img [^>]*oa_badge\\.png[^>]*>\\s*</a>')
    oa_link <- if (!is.na(oa_match)) str_extract(oa_match, 'href="([^"]+)"') else NA
    oa_link <- if (!is.na(oa_link)) str_replace(oa_link, 'href="([^"]+)"', "\\1") else NA
    
    # OpenData
    data_match <- str_extract(li, '<a href="[^"]+">\\s*<img [^>]*data_small_color\\.png[^>]*>\\s*</a>')
    data_link <- if (!is.na(data_match)) str_extract(data_match, 'href="([^"]+)"') else NA
    data_link <- if (!is.na(data_link)) str_replace(data_link, 'href="([^"]+)"', "\\1") else NA
    
    # Preregistration
    prereg_match <- str_extract(li, '<a href="[^"]+">\\s*<img [^>]*preregistered_small_color\\.png[^>]*>\\s*</a>')
    prereg_link <- if (!is.na(prereg_match)) str_extract(prereg_match, 'href="([^"]+)"') else NA
    prereg_link <- if (!is.na(prereg_link)) str_replace(prereg_link, 'href="([^"]+)"', "\\1") else NA
    
    # OpenMaterial
    material_match <- str_extract(li, '<a href="[^"]+">\\s*<img [^>]*materials_small_color\\.png[^>]*>\\s*</a>')
    material_link <- if (!is.na(material_match)) str_extract(material_match, 'href="([^"]+)"') else NA
    material_link <- if (!is.na(material_link)) str_replace(material_link, 'href="([^"]+)"', "\\1") else NA
    
    # Add to data frame
    result_df <- rbind(result_df, data.frame(
      doi = doi,
      OpenAccess = oa_link,
      OpenData = data_link,
      Preregistration = prereg_link,
      OpenMaterial = material_link,
      stringsAsFactors = FALSE
    ))
  }
  
  return(result_df)
}


# Read HTML content from a file
html_from_file <- readLines("Material/Publications – nicebread.de.html", warn=FALSE)
html_from_file <- paste(html_from_file, collapse = "\n")

# Process the content from file
result_from_file <- extract_info(html_from_file)

# Display or save the result
print(result_from_file)

library(rio)
export(result_from_file, "publist.xlsx")