extension ListExtensions<T> on List<T> {
  
  // ===== Safety Checks =====
  
  /// Check if list is null or empty
  /// Example: [].isNullOrEmpty → true
  bool get isNullOrEmpty => isEmpty;
  
  /// Check if list is not null and not empty
  /// Example: [1, 2, 3].isNotNullOrEmpty → true
  bool get isNotNullOrEmpty => isNotEmpty;
  
  // ===== Safe Access =====
  
  /// Get element at index safely (returns null if out of bounds)
  /// Example: [1, 2, 3].getOrNull(5) → null
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
  
  /// Get element at index or return default value
  /// Example: [1, 2, 3].getOrDefault(5, 0) → 0
  T getOrDefault(int index, T defaultValue) {
    if (index < 0 || index >= length) return defaultValue;
    return this[index];
  }
  
  /// Get first element safely (returns null if empty)
  /// Example: [].firstOrNull → null
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
  
  /// Get last element safely (returns null if empty)
  /// Example: [].lastOrNull → null
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
  
  // ===== Chunking =====
  
  /// Split list into chunks of specified size
  /// Example: [1, 2, 3, 4, 5].chunk(2) → [[1, 2], [3, 4], [5]]
  List<List<T>> chunk(int size) {
    if (size <= 0) throw ArgumentError('Size must be positive');
    
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
  
  // ===== Unique =====
  
  /// Remove duplicates from list
  /// Example: [1, 2, 2, 3, 3, 3].unique → [1, 2, 3]
  List<T> get unique {
    return toSet().toList();
  }
  
  /// Remove duplicates based on key
  /// Example: users.uniqueBy((u) => u.id)
  List<T> uniqueBy<K>(K Function(T) keyExtractor) {
    final seen = <K>{};
    return where((item) {
      final key = keyExtractor(item);
      if (seen.contains(key)) {
        return false;
      } else {
        seen.add(key);
        return true;
      }
    }).toList();
  }
  
  // ===== Counting =====
  
  /// Count elements matching condition
  /// Example: [1, 2, 3, 4, 5].count((x) => x > 3) → 2
  int count(bool Function(T) test) {
    return where(test).length;
  }
  
  // ===== Grouping =====
  
  /// Group elements by key
  /// Example: users.groupBy((u) => u.country)
  Map<K, List<T>> groupBy<K>(K Function(T) keyExtractor) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keyExtractor(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }
  
  // ===== Partition =====
  
  /// Partition list into two lists based on condition
  /// Example: [1, 2, 3, 4].partition((x) => x % 2 == 0) → ([2, 4], [1, 3])
  (List<T>, List<T>) partition(bool Function(T) test) {
    final matched = <T>[];
    final unmatched = <T>[];
    
    for (final item in this) {
      if (test(item)) {
        matched.add(item);
      } else {
        unmatched.add(item);
      }
    }
    
    return (matched, unmatched);
  }
  
  // ===== Sum & Average (for numbers) =====
  
  /// Sum all elements (only for num types)
  /// Example: [1, 2, 3, 4, 5].sum → 15
  num get sum {
    if (T != int && T != double && T != num) {
      throw UnsupportedError('sum() only works with numeric types');
    }
    return fold<num>(0, (sum, item) => sum + (item as num));
  }
  
  /// Average of all elements (only for num types)
  /// Example: [1, 2, 3, 4, 5].average → 3.0
  double get average {
    if (isEmpty) return 0;
    return sum / length;
  }
  
  // ===== Min & Max =====
  
  /// Get minimum value (for comparable types)
  /// Example: [5, 2, 8, 1, 9].min → 1
  T? get min {
    if (isEmpty) return null;
    return reduce((a, b) => (a as Comparable).compareTo(b) < 0 ? a : b);
  }
  
  /// Get maximum value (for comparable types)
  /// Example: [5, 2, 8, 1, 9].max → 9
  T? get max {
    if (isEmpty) return null;
    return reduce((a, b) => (a as Comparable).compareTo(b) > 0 ? a : b);
  }
  
  // ===== Sorting =====
  
  /// Sort list by key
  /// Example: users.sortedBy((u) => u.name)
  List<T> sortedBy<K extends Comparable>(K Function(T) keyExtractor) {
    final copy = List<T>.from(this);
    copy.sort((a, b) => keyExtractor(a).compareTo(keyExtractor(b)));
    return copy;
  }
  
  /// Sort list by key descending
  /// Example: users.sortedByDescending((u) => u.age)
  List<T> sortedByDescending<K extends Comparable>(K Function(T) keyExtractor) {
    final copy = List<T>.from(this);
    copy.sort((a, b) => keyExtractor(b).compareTo(keyExtractor(a)));
    return copy;
  }
  
  // ===== Take & Skip =====
  
  /// Take first n elements
  /// Example: [1, 2, 3, 4, 5].takeFirst(3) → [1, 2, 3]
  List<T> takeFirst(int n) {
    if (n <= 0) return [];
    if (n >= length) return this;
    return sublist(0, n);
  }
  
  /// Take last n elements
  /// Example: [1, 2, 3, 4, 5].takeLast(3) → [3, 4, 5]
  List<T> takeLast(int n) {
    if (n <= 0) return [];
    if (n >= length) return this;
    return sublist(length - n);
  }
  
  /// Skip first n elements
  /// Example: [1, 2, 3, 4, 5].skipFirst(2) → [3, 4, 5]
  List<T> skipFirst(int n) {
    if (n <= 0) return this;
    if (n >= length) return [];
    return sublist(n);
  }
  
  /// Skip last n elements
  /// Example: [1, 2, 3, 4, 5].skipLast(2) → [1, 2, 3]
  List<T> skipLast(int n) {
    if (n <= 0) return this;
    if (n >= length) return [];
    return sublist(0, length - n);
  }
  
  // ===== Random =====
  
  /// Get random element
  /// Example: [1, 2, 3, 4, 5].random → (random element)
  T? get random {
    if (isEmpty) return null;
    return this[(length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor()];
  }
  
  /// Shuffle list (returns new list)
  /// Example: [1, 2, 3, 4, 5].shuffled → [3, 1, 5, 2, 4]
  List<T> get shuffled {
    final copy = List<T>.from(this);
    copy.shuffle();
    return copy;
  }
  
  // ===== Intersperse =====
  
  /// Insert separator between elements
  /// Example: [1, 2, 3].intersperse(0) → [1, 0, 2, 0, 3]
  List<T> intersperse(T separator) {
    if (length <= 1) return this;
    
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
  
  // ===== Join to String =====
  
  /// Join elements with separator
  /// Example: [1, 2, 3].joinToString(', ') → "1, 2, 3"
  String joinToString([String separator = '']) {
    return map((e) => e.toString()).join(separator);
  }
  
  // ===== All & Any & None =====
  
  /// Check if all elements match condition
  /// Example: [2, 4, 6].all((x) => x % 2 == 0) → true
  bool all(bool Function(T) test) {
    return every(test);
  }
  
  /// Check if no elements match condition
  /// Example: [1, 3, 5].none((x) => x % 2 == 0) → true
  bool none(bool Function(T) test) {
    return !any(test);
  }
  
  // ===== Replace =====
  
  /// Replace element at index
  /// Example: [1, 2, 3].replaceAt(1, 5) → [1, 5, 3]
  List<T> replaceAt(int index, T newValue) {
    if (index < 0 || index >= length) return this;
    final copy = List<T>.from(this);
    copy[index] = newValue;
    return copy;
  }
  
  /// Replace first occurrence
  /// Example: [1, 2, 3, 2].replaceFirst(2, 5) → [1, 5, 3, 2]
  List<T> replaceFirst(T oldValue, T newValue) {
    final copy = List<T>.from(this);
    final index = copy.indexOf(oldValue);
    if (index != -1) {
      copy[index] = newValue;
    }
    return copy;
  }
  
  /// Replace all occurrences
  /// Example: [1, 2, 3, 2].replaceAll(2, 5) → [1, 5, 3, 5]
  List<T> replaceAll(T oldValue, T newValue) {
    return map((item) => item == oldValue ? newValue : item).toList();
  }
  
  // ===== Compact (remove nulls) =====
  
  /// Remove null values (only for nullable lists)
  /// Example: [1, null, 2, null, 3].compact() → [1, 2, 3]
  List<T> compact() {
    return where((item) => item != null).toList();
  }
  
  // ===== Flatten (for nested lists) =====
  
  /// Flatten nested list (one level deep)
  /// Example: [[1, 2], [3, 4], [5]].flatten() → [1, 2, 3, 4, 5]
  List<E> flatten<E>() {
    if (T == List<E>) {
      return expand((item) => item as List<E>).toList();
    }
    throw UnsupportedError('flatten() only works with List<List<E>>');
  }
}

// ===== String List Extensions =====
extension StringListExtensions on List<String> {
  
  /// Join with comma and space
  /// Example: ['a', 'b', 'c'].joinWithComma() → "a, b, c"
  String joinWithComma() => join(', ');
  
  /// Join with newline
  /// Example: ['a', 'b', 'c'].joinWithNewline() → "a\nb\nc"
  String joinWithNewline() => join('\n');
  
  /// Filter empty strings
  /// Example: ['a', '', 'b', '', 'c'].filterEmpty() → ['a', 'b', 'c']
  List<String> filterEmpty() => where((s) => s.isNotEmpty).toList();
  
  /// Trim all strings
  /// Example: [' a ', ' b ', ' c '].trimAll() → ['a', 'b', 'c']
  List<String> trimAll() => map((s) => s.trim()).toList();
}