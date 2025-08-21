import Image from 'next/image'

export type ValidIconSize =
  | 140
  | 128
  | 100
  | 96
  | 80
  | 76
  | 70
  | 68
  | 64
  | 48
  | 42
  | 40
  | 36
  | 34
  | 32
  | 30
  | 28
  | 24
  | 20
  | 18
  | 16
  | 14
  | 12
  | 8
  | 6
  | 4
  | 'auto'

interface IconProps {
  type: string
  size?: ValidIconSize
  rotate?: number
  color?: string
}

export const Icon = ({ type, size = 24, rotate, color = 'currentColor' }: IconProps) => {
  // Path to your public SVG
  const src = `/assets/svg/${type}.svg`

  // Handle auto size
  const iconSize = size === 'auto' ? undefined : size

  const style: React.CSSProperties = {
    transform: rotate ? `rotate(${rotate}deg)` : undefined,
    width: iconSize ? `${iconSize}px` : undefined,
    height: iconSize ? `${iconSize}px` : undefined,
    // Note: You cannot set the fill color of an external SVG via CSS unless the SVG itself uses currentColor.
    color,
    display: 'inline-block',
    verticalAlign: 'middle'
  }

  // If you want to handle SVG not found, you would need to check for its existence at build time or use a fallback image.
  // For runtime fallback, you could use onError for <img> but not for <Image />.

  return (
    <span className="icon" style={style}>
      <Image
        src={src}
        alt={type}
        width={iconSize || 24}
        height={iconSize || 24}
        style={{
          width: iconSize ? `${iconSize}px` : undefined,
          height: iconSize ? `${iconSize}px` : undefined,
          objectFit: 'contain',
          ...(color !== 'currentColor' ? { filter: `drop-shadow(0 0 0 ${color})` } : {})
        }}
        // Optionally, add priority or other Next.js Image props here
      />
    </span>
  )
}
