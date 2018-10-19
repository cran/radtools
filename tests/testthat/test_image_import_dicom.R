test_that("Invalid DICOM files", {
  skip_on_cran()
  expect_error(read_dicom(paste(dir_d_clunie_dicom_deflate, "image_dfl", sep = "/")))
  expect_error(read_dicom(paste(dir_s_barre_dicom, "OT-MONO2-8-colon", sep = "/"))) # Missing 4-byte DICOM prefix
  expect_error(read_dicom(paste(dir_s_barre_dicom, "OT-PAL-8-face", sep = "/"))) # Missing 4-byte DICOM prefix
})

test_that("D. Clunie scsgreek", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_dclunie_scsgreek, 1))
  expect_error(img_data_to_mat(dicom_data_dclunie_scsgreek))
})

test_that("D. Clunie scx2", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_dclunie_scsx2, 1))
  expect_error(img_data_to_mat(dicom_data_dclunie_scsx2))
})

test_that("D. Clunie deflate image", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_dclunie_image, 1))
  expect_error(img_data_to_mat(dicom_data_dclunie_image))
})

test_that("S. Barre ort", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_ort, 1))
  expect_error(img_data_to_mat(dicom_data_sbarre_ort))
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_ort))
})

test_that("S. Barre heart MR", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_heart_mr, 1))
  expect_error(img_data_to_mat(dicom_data_sbarre_heart_mr))
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_heart_mr))
})

test_that("S. Barre heart NM", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_heart_nm, 1))
  expect_error(img_data_to_mat(dicom_data_sbarre_heart_nm))
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_heart_nm))
})

test_that("S. Barre execho", {
  skip_on_cran()
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_execho, 1))
  expect_error(img_data_to_mat(dicom_data_sbarre_execho))
  expect_error(img_data_to_3D_mat(dicom_data_sbarre_execho))
})

test_that("DICOM image data to 3D matrix", {
  skip_on_cran()
  expect_equal(dim(img_data_to_3D_mat(dicom_data_chest)), c(512, 512, 128))
  expect_equal(dim(img_data_to_3D_mat(dicom_data_prostate_mr)), c(384, 384, 19))
  expect_equal(dim(img_data_to_3D_mat(dicom_data_prostate_pt)), c(144, 144, 234))
  expect_error(img_data_to_3D_mat(dicom_data_chest, coord_extra_dim = 1))
  expect_error(img_data_to_3D_mat(dicom_data_bladder)) # Data is missing required header fields for oro.dicom::create3D()
  expect_equal(dim(img_data_to_3D_mat(sample_dicom_img)), c(256, 256, 3))
  expect_error(img_data_to_3D_mat(sample_dicom_img, coord_extra_dim = 1))
  expect_equal(dim(img_data_to_3D_mat(dicom_data_988_MR700)), c(512, 512, 12))
  expect_error(img_data_to_3D_mat(dicom_data_988_MR700, coord_extra_dim = 1))
  expect_warning(dim(img_data_to_3D_mat(dicom_data_247_MR3)))
  expect_error(img_data_to_3D_mat(dicom_data_247_MR3, coord_extra_dim = 1))
  expect_error(img_data_to_3D_mat(dicom_data_247_OT))
  expect_error(img_data_to_3D_mat(dicom_data_247_OT, coord_extra_dim = 1))
})

test_that("DICOM image data to 3D matrix - for CRAN", {
  expect_equal(dim(img_data_to_3D_mat(sample_dicom_img)), c(256, 256, 3))
  expect_error(img_data_to_3D_mat(sample_dicom_img, coord_extra_dim = 1))
})

test_that("DICOM image data to matrix", {
  skip_on_cran()
  expect_equal(dim(img_data_to_mat(dicom_data_chest)), c(512, 512, 128))
  expect_equal(dim(img_data_to_mat(dicom_data_prostate_mr)), c(384, 384, 19))
  expect_equal(dim(img_data_to_mat(dicom_data_prostate_pt)), c(144, 144, 234))
  expect_error(img_data_to_mat(dicom_data_bladder)) # Data is missing required header fields for oro.dicom::create3D()
  expect_equal(dim(img_data_to_mat(sample_dicom_img)), c(256, 256, 3))
  expect_equal(dim(img_data_to_mat(dicom_data_988_MR700)), c(512, 512, 12))
})

test_that("DICOM image data to matrix - for CRAN", {
  expect_equal(dim(img_data_to_mat(sample_dicom_img)), c(256, 256, 3))
})

test_that("Matrix reduce dimensions", {
  skip_on_cran()

  expect_error(mat_reduce_dim(1:5))

  mat0 <- NULL
  expect_error(mat_reduce_dim(mat0, 5))

  mat1 <- array(1:5)
  expect_equal(mat_reduce_dim(mat1, NULL), mat1)
  expect_equal(mat_reduce_dim(mat1, 5), 5)
  expect_error(mat_reduce_dim(mat1, c(1,2)))

  mat2 <- array(dim = c(5,5))
  mat2[2,3] <- 3
  mat2[5,2] <- 5
  expect_equal(mat_reduce_dim(mat2, 3), c(NA, 3, NA, NA, NA))
  expect_equal(mat_reduce_dim(mat2, 2), c(NA, NA, NA, NA, 5))
  expect_equal(mat_reduce_dim(mat2, c(2,3)), 3)
  expect_true(is.na(mat_reduce_dim(mat2, c(2,4))))

  mat3 <- array(dim = c(5,5,5))
  mat3[1,2,3] <- 4
  expect_error(mat_reduce_dim(mat3, c(1,2,3,4)))
  expect_equal(mat_reduce_dim(mat3, 3)[1,2], 4)
  expect_equal(dim(mat_reduce_dim(mat3, 3)), c(5,5))
  expect_equal(length(mat_reduce_dim(mat3, c(2,2))), 5)
  expect_equal(length(mat_reduce_dim(mat3, c(2,2,2))), 1)

})
