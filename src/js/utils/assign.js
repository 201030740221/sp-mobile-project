/**
 * Object assign 补丁, 合并对象
 * @see  https://developer.mozilla.org/pl/docs/Web/JavaScript/Reference/Global_Objects/Object/assign
 */

function ToObject(val) {
	if (val === null) {
		throw new TypeError('Object.assign cannot be called with null or undefined');
	}

	return Object(val);
}

module.exports = Object.assign || function (target) {
	var from;
	var keys;
	var to = ToObject(target);

	for (var s = 1; s < arguments.length; s++) {
		from = arguments[s];
		keys = Object.keys(Object(from));

		for (var i = 0; i < keys.length; i++) {
			to[keys[i]] = from[keys[i]];
		}
	}

	return to;
};
