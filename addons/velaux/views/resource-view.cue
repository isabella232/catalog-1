resource - view.cue
import (
"vela/ql",
)

parameter: {
	type:      string
	namespace: *"" | string
	cluster:   *"" | string
}

schema: {
	"secret": {
		apiVersion: "v1"
		kind:       "Secret"
	}
	"configMap": {
		apiVersion: "v1"
		kind:       "ConfigMap"
	}
	"pvc": {
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
	}
	"storageClass": {
		apiVersion: "storage.k8s.io/v1"
		kind:       "StorageClass"
	}
	"ns": {
		apiVersion: "v1"
		kind:       "Namespace"
	}
	"provider": {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
	}
}

List: ql.#List & {
	resource: schema[parameter.type]
	filter: {
		namespace: parameter.namespace
	}
	cluster: parameter.cluster
}

status: {
	if List.err == _|_ {
		if len(List.list.items) == 0 {
			error: "failed to list \(parameter.type) in namespace \(parameter.namespace)"
		}
		if len(List.list.items) != 0 {
			list: List.list.items
		}
	}

	if List.err != _|_ {
		error: List.err
	}
}
