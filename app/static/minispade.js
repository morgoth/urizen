if (typeof document !== "undefined") {
    (function() {
        minispade = {
            root: null,
            modules: {},
            loaded: {},

            require: function(name) {
                var loaded = minispade.loaded[name];
                var mod = minispade.modules[name];

                if (!loaded) {
                    if (mod) {
                        minispade.loaded[name] = true;

                        if (typeof mod === "string") {
                            eval(mod);
                        } else {
                            mod();
                        }
                    } else {
                        if (minispade.root && name.substr(0,minispade.root.length) !== minispade.root) {
                            return minispade.require(minispade.root+name);
                        } else {
                            throw "The module '" + name + "' could not be found";
                        }
                    }
                }

                return loaded;
            },

            register: function(name, callback) {
                minispade.modules[name] = callback;
            }
        };

        require = minispade.require;
    })();
}
