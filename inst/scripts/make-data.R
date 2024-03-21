#########################
#########################
#Training Code:
##########################
#########################

#Dat are transformed arrays/matrices using either OHE or amino acid property
#to translate sequences into numerical values. 

#########################
#Traditional Autoencoder
#########################
library(keras)
#Sampling to make Training/Valid Data
set.seed(42)
num_sequences <- nrow(dat)
indices <- 1:num_sequences
train_indices <- sample(indices, size = floor(0.8 * num_sequences))
val_indices <- setdiff(indices, train_indices)
x_train <- dat[train_indices,]
x_val <- dat[val_indices,]
rm(dat)
gc()

# Parameters
input_shape <- dim(x_train)[2]
epochs <- 100
batch_size <- 64
encoding_dim <- 30  
hidden_dim1 <- 256 # Hidden layer 1 size
hidden_dim2 <- 128  # Hidden layer 2 size

#Early Stop Call
es = callback_early_stopping(
  monitor = "val_loss",
  min_delta = 0,
  patience = 10,
  verbose = 1,
  mode = "min")

# Define the Model
input_seq <- layer_input(shape = c(input_shape))

# Encoder Layers
encoded <- input_seq %>%
  layer_dense(units = hidden_dim1, activation = 'relu', name = "e.1") %>%
  layer_batch_normalization() %>%
  layer_dense(units = hidden_dim2, activation = 'relu', name = "e.2") %>%
  layer_batch_normalization() %>%
  layer_dense(units = encoding_dim, activation = 'relu', name = "latent")

# Decoder Layers
decoded <- encoded %>%
  layer_dense(units = hidden_dim2, activation = 'relu', name = "d.2") %>%
  layer_batch_normalization() %>%
  layer_dense(units = hidden_dim1, activation = 'relu', name = "d.1") %>%
  layer_batch_normalization() %>%
  layer_dense(units = input_shape, activation = 'sigmoid')

lr <- 0.0000005

# Autoencoder Model
autoencoder <- keras_model(input_seq, decoded)
autoencoder %>% keras::compile(optimizer = optimizer_adam(learning_rate = lr),
                               loss = "mse")

# Train the model
history <- autoencoder %>% fit(
  x = x_train,
  y = x_train,
  validation_data = list(x_val, x_val),
  epochs = epochs,
  batch_size = batch_size,
  shuffle = TRUE,
  callbacks = es
)

encoder <- keras_model(input_seq, encoded)

save_model_hdf5(encoder, "./models/Chain_Method_EncoderType.h5")

#########################
#VAE Autoencoder
#########################

library(keras)
tensorflow::tf$compat$v1$disable_v2_behavior()

#Sampling to make Training/Valid Data
set.seed(42)
num_sequences <- nrow(dat)
indices <- 1:num_sequences
train_indices <- sample(indices, size = floor(0.8 * num_sequences))
val_indices <- setdiff(indices, train_indices)
x_train <- dat[train_indices,]
x_val <- dat[val_indices,]
rm(dat)
gc()

# Parameters
input_shape <- dim(x_train)[2]
epochs <- 100
batch_size <- 64
encoding_dim <- 30  
hidden_dim1 <- 256 # Hidden layer 1 size
hidden_dim2 <- 128  # Hidden layer 2 size
epsilon_std<-1

es = callback_early_stopping(
  monitor = "val_loss",
  min_delta = 0,
  patience = 10,
  verbose = 1,
  mode = "min")

input_seq <- layer_input(shape = c(input_shape))
h1 <- layer_dense(input_seq, units = hidden_dim1, activation = 'relu',  name = "e.1")
h2 <- layer_dense(h1, units = hidden_dim2, activation = 'relu',  name = "e.2")
z_mean <- layer_dense(h2, encoding_dim, name = "latent")
z_log_var <- layer_dense(h2, encoding_dim, name = "log_var")

# Modification due to pycapsule issue with reparametization layer
sampling <- function(arg){
  z_mean <- arg[, 1:(encoding_dim)]
  z_log_var <- arg[, (encoding_dim + 1):(2 * encoding_dim)]
  
  epsilon <- keras::k_random_normal(
    shape = c(keras::k_shape(z_mean)[[1]]),
    mean=0.,
    stddev=epsilon_std
  )
  
  z_mean + keras::k_exp(z_log_var/2)*epsilon
}

z <- keras::layer_concatenate(list(z_mean, z_log_var)) %>%
  keras::layer_lambda(sampling, name = "lambda")

# Decoder
decoder_h1 <- layer_dense(units = hidden_dim2, activation = 'relu',  name = "d.1")
decoder_h2 <- layer_dense(units = hidden_dim1, activation = 'relu', name = "d.2")
decoder_out <- layer_dense(units = input_shape, activation = 'sigmoid')

h1_decoded <- decoder_h1(z)
h2_decoded <- decoder_h2(h1_decoded)
output_layer <- decoder_out(h2_decoded)

# VAE Model
vae <- keras_model(inputs = input_seq, outputs = output_layer)

# Loss and Compilation
reconstruction_loss <- function(y_true, y_pred) {
  k_mean(loss_binary_crossentropy(y_true, y_pred), axis = c(-1))
}

kl_loss <- function(y_true, y_pred) {
  -0.5 * k_sum(1 + z_log_var - k_square(z_mean) - k_exp(z_log_var), axis = -1)
}

vae_loss <- function(y_true, y_pred) {
  reconstruction_loss(y_true, y_pred) + kl_loss(y_true, y_pred)
}

vae %>% keras::compile(optimizer = tf$keras$optimizers$legacy$Adam(0.00000001),
                       loss = vae_loss, 
                       metrics = c("mse"))


# Train the model
history <- vae %>% fit(
  x = x_train,
  y = x_train,
  validation_data = list(x_val, x_val),
  epochs = epochs,
  batch_size = batch_size,
  shuffle = TRUE,
  callbacks = es
)

encoder <- keras_model(inputs = input_seq, outputs = z_mean)

save_model_hdf5(encoder, "./models/Chain_Method_EncoderType.h5")