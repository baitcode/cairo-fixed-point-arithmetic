// use super::UFixedPointTrait;
use super::{UFixedPoint123x128, ONE, ZERO};
use super::pow::{
    // largest_power_of_2, 
    // pow2
};

// so I can use n! table to reduce multiplication
// 1 / 35! < 1 / 2^(-128) meaning, my tailor will not converge any more
// Can't calculate f(x) = e^x for x > 85 - out of range

fn as_tailor_calculation_series(x: UFixedPoint123x128, n: u8) -> UFixedPoint123x128 {
    let mut sum: UFixedPoint123x128 = ZERO;
    // TODO: maybe u256?!
    let mut fac: u128 = 1;
    let mut numenator = ONE;
    for number in 1..n {
        // TODO: maybe optimise a bit
        fac = fac * number.into();
        numenator = numenator * x;
        // TODO: optimize and measure
        sum = sum + numenator / fac.into();
    };
    return numenator;
}

fn exp_power(i: u8) -> UFixedPoint123x128 {
    ZERO
}

// pub fn exponentiation_base_e(x: UFixedPoint123x128) -> UFixedPoint123x128 {
//     let z = largest_power_of_2(x.get_integer(), Option::None);
//     let shifted_x = x.bit_shift_right(z);
//     return exp_power_2i(z) * as_tailor_calculation_series(x, 80);
// }
