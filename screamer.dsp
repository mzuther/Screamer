declare name       "Screamer";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";

import("stdfaust.lib");


sample_and_hold = (ro.cross(2) , _ : _ != 0.0 , _ , _ : select2 : _) ~ _;

trigger = 1;
process = trigger, _ : sample_and_hold : _;
