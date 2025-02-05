// Basic type import
use fp::{ UFixedPoint123x128 };
use fp::exp::{ exp_power_static };

// Store packing implementation import
use fp::{ UFixedPoint123x128StorePacking };

// Convenience functions to avoid type conversions
use fp::{
    div_u64_by_u128, 
    div_u64_by_fixed_point, 
    mul_fixed_point_by_u128
};

fn main() {
    // Create a fixed point value 1.0
    let one: UFixedPoint123x128 = 1_u64.into();
    // Create a fixed point value 100.0
    let hundred: UFixedPoint123x128 = 100_u64.into();
    // Calculate a fixed point value 0.01
    let one_over_hundred = one / hundred;
    // OR
    let other_example = div_u64_by_u128(1, 100);

    let multiplication_is_supported = one_over_hundred * hundred;
    
    let two: UFixedPoint123x128 = 2_u64.into();
    let three: UFixedPoint123x128 = 3_u64.into();
    let six: UFixedPoint123x128 = 6_u64.into();
    let one_over_three = one / three;
    let one_over_six = one / six;

    // PartialEq is implemented, values are equal if they are close enough.
    // Difference is less than 1 / 2^124
}
