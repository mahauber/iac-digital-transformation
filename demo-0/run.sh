#!/bin/bash

az login --tenant 60fb1cfc-a9ef-4a93-b5e8-5d021bd6f296

tofu init
tofu apply
