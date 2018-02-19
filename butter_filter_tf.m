function [filter_tf] = butter_filter_tf(order, cutoff_frequency)

wc= cutoff_frequency * 2 * pi;
w = 1/wc;

switch order
    case 1
        filter_tf = tf(1,[w 1]);
    case 2
        filter_tf = tf(1,[w^2 1.4142*w 1]);
    case 3
        syms s;
        x = s*w;
        den = expand((x + 1)*(x^2 + x+ 1));
        filter_tf = tf(1,double(coeffs(den,'All')));
    case 4
        syms s;
        x = s*w;
        den = expand((x^2 + 0.7654*x +1) * (x^2 + 1.8478*x + 1));
        filter_tf = tf(1, double(coeffs(den,'All')));
    case 5
        syms s;
        x = s*w;
        den = expand((x + 1) * (x^2 + 0.6180*x + 1) * (x^2 + 1.8478*x + 1));
        filter_tf = tf(1, double(coeffs(den,'All')));
    case 6
        syms s;
        x = s*w;
        den = expand((x^2 + 0.5176*x + 1) * (x^2 + 1.4142*x + 1) * (x^2 + 1.9319*x + 1));
        filter_tf = tf(1, double(coeffs(den, 'All')));
    case 7
        syms s;
        x = s*w;
        den = expand((x + 1) * (x^2 + 0.4450*x + 1) * (x^2 + 1.2470*x + 1) * (x^2 + 1.8019 * x + 1));
        filter_tf = tf(1, double(coeffs(den, 'All')));
    case 8 
        syms s;
        x = s*w;
        den = expand((x^2 + 0.3902*x + 1) * (x^2 + 1.1111*x + 1) * (x^2 + 1.6629*x + 1) * (x^2 + 1.9616*x + 1));
        filter_tf = tf(1, double(coeffs(den, 'All')));
end
end