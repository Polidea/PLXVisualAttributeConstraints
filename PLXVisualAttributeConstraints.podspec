Pod::Spec.new do |spec|
  spec.name = 'PLXVisualAttributeConstraints'
  spec.version =  '1.0.0'
  spec.summary =  'Custom VFL (Visual Format Language) for creating NSLayoutConstraint's.'
  spec.description = 'Offers more readable and concise replacement for constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant: (NSLayoutConstraint, AutoLayout mechanism).'
  spec.homepage = 'https://github.com/Polidea/PLXVisualAttributeConstraints'
  spec.license = {
    :type => 'BSD',
    :file => 'BSD.LICENSE'
  }
  spec.authors = {
    'Polidea' => 'kamil.jaworski@polidea.com'
  },
  spec.platform = :ios, "6.0"
  spec.source = {
    :git => 'https://github.com/Polidea/PLXVisualAttributeConstraints.git',
    :tag => '1.0.0'
  }
  spec.source_files = 'PLXVisualAttributeConstraints/PLXVisualAttributeConstraints/**/*.{h,m}'
  spec.requires_arc = true
end
