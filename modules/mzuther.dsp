// impulse train: a one followed by an infinite number of zeros
impulse_train = 1.0 - 1.0';


//               +---------+
//    index ---> |         |
//               |         |
// stream_0 ---> | select2 | ---> output
//               |         |
// stream_1 ---> |         |
//               +---------+
//
// If "index" is 0.0, the output is "stream_0", and if "index" is 1.0,
// the output is "stream_1".  Otherwise, the output is 0, and an error
// can occur during execution.
//
//
//               +--------------+
//    index ---> |              |
//               |              |
// stream_0 ---> | if_then_else | ---> output
//               |              |
// stream_1 ---> |              |
//               +--------------+
//
// If "index" is exactly 0.0, the output is "stream_1".  In any other
// case, the output is "stream_0".
if_then_else = _ == 0.0 , _ , _ : select2;


// create a stereo effect
stereo(mono) = par(i , 2 , mono);


// recursion_with_initial_value = _ : +(_) ~ *(0.5) : _;
