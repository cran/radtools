## ----setup, include = FALSE----------------------------------------------
rm(list=ls())
suppressPackageStartupMessages(library(knitr))
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE
)

## ----suppress_eval, echo = FALSE-----------------------------------------
# Check if this is running locally and if not, suppress evaluation
if(!utils::file_test("-f", "~/Dropbox/radtools_vignette_data/prostate/000008.dcm")) {
  knitr::opts_chunk$set(eval = FALSE)
  message("Note: code examples will not be evaluated because they depend on local data.")
}

## ----import_package, warning = FALSE, message = FALSE--------------------
dicom_data <- radtools::read_dicom("~/Dropbox/radtools_vignette_data/prostate/")
nifti_data_rad <- radtools::read_nifti1("~/Dropbox/radtools_vignette_data/filtered_func_data.nii.gz")
nifti_data_oro <- oro.nifti::readNIfTI("~/Dropbox/radtools_vignette_data/filtered_func_data.nii.gz")

## ----img_dim_rad---------------------------------------------------------
radtools::img_dimensions(dicom_data)
radtools::img_dimensions(nifti_data_rad)
radtools::num_slices(dicom_data)
radtools::num_slices(nifti_data_rad)

## ----img_dim_oro---------------------------------------------------------
mat_dicom <- oro.dicom::create3D(dicom_data)
dim(mat_dicom)
dim(nifti_data_oro)
dim(mat_dicom)[3] # Number of slices
dim(nifti_data_oro)[3] # Number of slices

## ----header_fields_rad---------------------------------------------------
fields <- radtools::header_fields(dicom_data)
head(fields, 10)

## ----header_field_oro----------------------------------------------------
tab <- oro.dicom::dicomTable(dicom_data$hdr)
fields <- colnames(tab)
head(fields, 10)

## ----header_fields_rad_n-------------------------------------------------
fields <- radtools::header_fields(nifti_data_rad)
head(fields, 10)

## ----header_value_rad----------------------------------------------------
radtools::header_value(dicom_data, "SliceLocation")

## ----header_value_oro----------------------------------------------------
oro.dicom::extractHeader(dicom_data$hdr, "SliceLocation")

## ----dicom_header_as_mat_rad, warning = FALSE----------------------------
mat <- radtools::dicom_header_as_matrix(dicom_data)
kable(mat[1:10, 1:6])

## ----dicom_header_as_mat_oro---------------------------------------------
mat <- oro.dicom::dicomTable(dicom_data$hdr)
kable(mat[1:10, 1:6])

## ------------------------------------------------------------------------
nifti_header_vals <- radtools::nifti1_header_values(nifti_data_rad)
head(nifti_header_vals[names(nifti_header_vals) != ".Data"])

## ----dicom_const_rad-----------------------------------------------------
const_attributes <- radtools::dicom_constant_header_values(dicom_data)
head(const_attributes)

## ----dicom_const_oro-----------------------------------------------------
tab <- oro.dicom::dicomTable(dicom_data$hdr)
const_cols <- apply(tab, 2, function(x) {length(unique(x)) == 1})
const_attributes <- as.list(tab[1, const_cols])
head(const_attributes)

## ----img_data_to_mat_rad-------------------------------------------------
mat_dicom <- radtools::img_data_to_mat(dicom_data)
dim(mat_dicom)
mat_nifti <- radtools::img_data_to_mat(nifti_data_rad)
dim(mat_nifti)

## ----img_data_to_mat_oro-------------------------------------------------
mat_dicom <- oro.dicom::create3D(dicom_data)
dim(mat_dicom)
mat_nifti <- oro.nifti::img_data(nifti_data_oro)
dim(mat_nifti)

## ----view_slice_rad, warning = FALSE, fig.width = 5, fig.height = 5------
radtools::view_slice(dicom_data, slice = 10)

## ----view_slice_oro, warning = FALSE, fig.width = 5, fig.height = 5------
mat <- oro.dicom::create3D(dicom_data)
m <- mat[,,10]
col <- grDevices::grey(0:64/64)
graphics::image(x = 1:nrow(m), y = 1:ncol(m), z = m, col = col, ann = FALSE)

## ---- fig.width = 5, fig.height = 5--------------------------------------
mat <- radtools::img_data_to_3D_mat(nifti_data_rad, coord_extra_dim = 90)
radtools::view_slice_mat(mat, slice = 10)

## ---- fig.width = 5, fig.height = 5--------------------------------------
oro.nifti::image(nifti_data_oro, z = 10, w = 90, plot.type = "single")

## ----dicom_standard_version----------------------------------------------
radtools::dicom_standard_version()
radtools::dicom_standard_web()
radtools::dicom_standard_timestamp()

## ----tags----------------------------------------------------------------
tags <- radtools::dicom_all_valid_header_tags()
head(tags, 10)

## ----names---------------------------------------------------------------
names <- radtools::dicom_all_valid_header_names()
head(names, 10)

## ----keywords------------------------------------------------------------
keywords <- radtools::dicom_all_valid_header_keywords()
head(keywords, 10)

## ----dicom_std_search----------------------------------------------------
radtools::dicom_search_header_names("manufacturer")
radtools::dicom_search_header_keywords("manufacturer")

## ----session_info--------------------------------------------------------
sessionInfo()

