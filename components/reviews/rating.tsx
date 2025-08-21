import { ItemStyles, Rating } from '@smastrom/react-rating'

const Star = (
  <svg
    version="1.1"
    id="svg51"
    width="64"
    height="64"
    viewBox="0 0 682.66669 682.66669"
    xmlns="http://www.w3.org/2000/svg"
  >
    <defs id="defs55">
      <clipPath clipPathUnits="userSpaceOnUse" id="clipPath65">
        <path d="M 0,512 H 512 V 0 H 0 Z" id="path63" />
      </clipPath>
    </defs>
    <g id="g57" transform="matrix(1.3333333,0,0,-1.3333333,0,682.66667)">
      <g id="g59">
        <g id="g61" clipPath="url(#clipPath65)">
          <g id="g67" transform="translate(227.0923,468.8169)">
            <path
              d="M 0,0 C 5.431,11 16.634,17.964 28.908,17.964 41.182,17.964 52.384,11 57.815,0 c 17.521,-35.5 38.539,-78.093 49.508,-100.32 4.698,-9.517 13.773,-16.11 24.274,-17.641 24.532,-3.562 71.54,-10.388 110.708,-16.086 12.145,-1.765 22.235,-10.267 26.022,-21.937 3.796,-11.669 0.629,-24.483 -8.156,-33.042 -28.343,-27.635 -62.361,-60.79 -80.107,-78.093 -7.6,-7.406 -11.065,-18.076 -9.276,-28.529 4.191,-24.435 12.226,-71.25 18.915,-110.265 2.071,-12.096 -2.893,-24.314 -12.822,-31.526 -9.929,-7.214 -23.09,-8.165 -33.953,-2.458 -35.033,18.422 -77.077,40.521 -99.022,52.062 -9.389,4.932 -20.607,4.932 -29.996,0 -21.945,-11.541 -63.99,-33.64 -99.022,-52.062 -10.864,-5.707 -24.025,-4.756 -33.953,2.458 -9.929,7.212 -14.893,19.43 -12.823,31.526 6.69,39.015 14.724,85.83 18.915,110.265 1.789,10.453 -1.676,21.123 -9.276,28.529 -17.746,17.303 -51.763,50.458 -80.107,78.093 -8.785,8.559 -11.952,21.373 -8.156,33.042 3.788,11.67 13.878,20.172 26.023,21.937 39.167,5.698 86.176,12.524 110.708,16.086 10.501,1.531 19.575,8.124 24.274,17.641 C -38.539,-78.093 -17.521,-35.5 0,0 Z"
              id="path69"
            />
          </g>
        </g>
      </g>
    </g>
  </svg>
)

export const BaseRating = (props: {
  initialValue?: number
  readonly?: boolean
  onChange?: (value: number) => void
  activeColor?: string
  inactiveColor?: string
}) => {
  const styles: ItemStyles = {
    itemShapes: Star,
    activeFillColor: props.activeColor ?? '#FFC107',
    inactiveFillColor: props.inactiveColor ?? 'var(--font_3)',
  }

  return (
    <Rating
      itemStyles={styles}
      readOnly={props.readonly}
      value={props.initialValue ?? 0}
      onChange={(value: number) => {
        props.onChange?.(value)
      }}
    />
  )
}
