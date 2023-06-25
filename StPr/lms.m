r = [wn - wn_; xi - xi_];
err_diff = sum(sqrerr(tout >= 300)) - sqr_err_;
sqr_err_ = sum(sqrerr(tout >= 300))
wn_ = wn;
xi_ = xi;
wn = wn - 0.1 * r(1) / err_diff
xi = xi - 0.1 * r(2) / err_diff