
export def get [] {

}

export def post [] {

}

export def put [] {

}

export def patch [] {

}

export def delete [] {

}

export def env [] {
  open './devops-conf/env.jsonc' | from json | load-env;
}
