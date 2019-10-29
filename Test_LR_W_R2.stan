data { 
  int <lower= 0> N; // Number of observation
  int <lower = 0> M; // Number of predictors
  matrix[N, M] X;   // predictor matrix
  vector[N] y; // Variates
  
}
parameters {
  vector[M] beta; // Slopes
  real alpha; // Intercept
  real <lower = 0> sigma; // Measurement Variability
}
model {
  vector[N] mu = X * beta + alpha; // mean response
  // Prior model
  for (m in 1:M)
  beta[m] ~ normal(0,5);
  alpha ~ normal(0,5);
  sigma ~ normal(0,5);
  
  //observational modekl
  for (n in 1:N)
  y[n] ~ normal(mu[n], sigma);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  vector[N] yhat;                // linear predictor
  real y_ppc[N];
  vector[N] log_lik;
  yhat = X * beta + alpha;
  
  {// These braces prevent temporary variabes, here mu, from being saved
  vector[N] mu = X * beta + alpha;
  for (n in 1:N)
  y_ppc[n] = normal_rng(mu[n], sigma);
} 
  {
for (n in 1:N) log_lik[n] = normal_lpdf(y[n] | X[n] * beta + alpha, sigma);
  }
  }